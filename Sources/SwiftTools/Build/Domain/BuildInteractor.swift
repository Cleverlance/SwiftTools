//
//  File.swift
//  
//
//  Created by Jan Halousek on 01.04.2022.
//

import Foundation

public protocol BuildInteractor {
    func build(with arguments: BuildArguments) throws
    func getBuildSettings(with arguments: BuildArguments) throws -> String
    func test(with arguments: TestArguments) throws
    func testWithLog(with arguments: TestArguments) throws -> String
}

final class BuildInteractorImpl: BuildInteractor {
    private let shellService: ShellService
    private let printService: PrintService
    private let verboseController: VerboseController
    private let getSimulatorId: GetSimulatorIdUseCase

    init(
        shellService: ShellService,
        printService: PrintService,
        verboseController: VerboseController,
        getSimulatorId: GetSimulatorIdUseCase
    ) {
        self.shellService = shellService
        self.printService = printService
        self.verboseController = verboseController
        self.getSimulatorId = getSimulatorId
    }

    func build(with arguments: BuildArguments) throws {
        let arguments = try makeArguments(
            scheme: arguments.scheme,
            platform: arguments.platform,
            arguments: arguments.arguments,
            isQuiet: !verboseController.isVerbose(),
            simulatorId: arguments.simulatorId
        )
        try shellService.execute(arguments: arguments)
    }

    func getBuildSettings(with arguments: BuildArguments) throws -> String {
        let arguments = try makeArguments(
            scheme: arguments.scheme,
            platform: arguments.platform,
            arguments: arguments.arguments + ["-showBuildSettings"],
            isQuiet: !verboseController.isVerbose(),
            simulatorId: arguments.simulatorId
        )
        return try shellService.executeWithResult(arguments: arguments)
    }

    func test(with arguments: TestArguments) throws {
        let arguments = try makeArguments(from: arguments)
        try shellService.executeWithXCBeautify(arguments: arguments)
    }

    func testWithLog(with arguments: TestArguments) throws -> String {
        let arguments = try makeArguments(from: arguments)
        return try shellService.executeWithResult(arguments: arguments)
    }

    private func makeArguments(from arguments: TestArguments) throws -> [String] {
        var additionalArguments = ["test"]
        if let testPlan = arguments.testPlan {
            additionalArguments += ["-testPlan", testPlan]
        }
        if arguments.isCodeCoverageEnabled {
            additionalArguments += ["-enableCodeCoverage", "YES"]
        }
        if arguments.skipMacroValidation {
            additionalArguments += ["-skipMacroValidation"]
        }
        return try makeArguments(
            scheme: arguments.scheme,
            platform: arguments.platform,
            arguments: additionalArguments,
            isQuiet: arguments.isQuiet,
            simulatorId: arguments.simulatorId
        )
    }

    private func makeArguments(
        scheme: String,
        platform: Platform?,
        arguments: [String],
        isQuiet: Bool,
        simulatorId: String?
    ) throws -> [String] {
        var buildArguments = ["xcodebuild", "COMPILER_INDEX_STORE_ENABLE=NO", "-scheme", scheme]
        if let platform = platform {
            let destination = try getDestination(for: platform, scheme: scheme, simulatorId: simulatorId)
            buildArguments += ["-destination", destination]
        }
        if isQuiet {
            buildArguments += ["-quiet"]
        }
        return buildArguments + arguments
    }

    private func getDestination(for platform: Platform, scheme: String, simulatorId: String?) throws -> String {
        let id = try simulatorId ?? getSimulatorId(for: platform, scheme: scheme)
        return getDestinationString(for: platform, with: id)
    }

    private func getDestinationString(for platform: Platform, with id: String) -> String {
        switch platform {
        case .iOS:
            return "\"platform=iOS Simulator,id=\(id)\""
        case .macOS:
            return "\"platform=macOS,variant=Mac Catalyst,id=\(id)\""
        }
    }
}

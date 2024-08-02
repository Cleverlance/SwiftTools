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

    init(shellService: ShellService, printService: PrintService, verboseController: VerboseController) {
        self.shellService = shellService
        self.printService = printService
        self.verboseController = verboseController
    }

    func build(with arguments: BuildArguments) throws {
        let arguments = try makeArguments(
            scheme: arguments.scheme,
            platform: arguments.platform,
            arguments: arguments.arguments,
            isQuiet: !verboseController.isVerbose()
        )
        try shellService.execute(arguments: arguments)
    }

    func getBuildSettings(with arguments: BuildArguments) throws -> String {
        let arguments = try makeArguments(
            scheme: arguments.scheme,
            platform: arguments.platform,
            arguments: arguments.arguments + ["-showBuildSettings"],
            isQuiet: !verboseController.isVerbose()
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
            isQuiet: arguments.isQuiet
        )
    }

    private func makeArguments(scheme: String, platform: Platform?, arguments: [String], isQuiet: Bool) throws -> [String] {
        var buildArguments = ["xcodebuild", "-scheme", scheme]
        if let platform = platform {
            let destination = try getDestination(for: platform, scheme: scheme)
            buildArguments += ["-destination", destination]
        }
        if isQuiet {
            buildArguments += ["-quiet"]
        }
        return buildArguments + arguments
    }

    private func getDestination(for platform: Platform, scheme: String) throws -> String {
        let keys = makeSearchedKeys(for: platform)
        let id = try getDeviceId(for: keys, scheme: scheme)
        return getDestinationString(for: platform, with: id)
    }

    private func getDeviceId(for keys: [String], scheme: String) throws -> String {
        let destinations = try shellService.executeWithResult(arguments: ["xcodebuild", "-scheme", scheme, "-showdestinations", "-quiet"])
        printService.printVerbose(destinations)
        let components = destinations
            .components(separatedBy: "\n")
        let destination = try components.first(where: { isRowValid(keys: keys, row: $0) }) ?!+ "missing simulator"
        let attributes = destination.split(separator: " ")
        let idKeyValue = try attributes.first(where: { $0.starts(with: "id:") }) ?!+ "missing id in simulator row"
        var id = idKeyValue.dropFirst(3)

        if idKeyValue.last == "," {
            id = id.dropLast(1)
        }

        printService.printVerbose("Selecting device with id: \(id), for keys: \(keys)")
        return String(id)
    }

    private func isRowValid(keys: [String], row: String) -> Bool {
        return keys.reduce(true, { $0 && row.contains($1) })
    }

    private func makeSearchedKeys(for platform: Platform) -> [String] {
        switch platform {
        case .iOS:
            return ["platform:iOS Simulator", " OS:"]
        case .macOS:
            return ["variant:Mac Catalyst"]
        }
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

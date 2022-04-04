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
        let arguments = try makeArguments(scheme: arguments.scheme, platform: arguments.platform, arguments: arguments.arguments)
        try shellService.execute(arguments: arguments)
    }

    func getBuildSettings(with arguments: BuildArguments) throws -> String {
        let arguments = try makeArguments(scheme: arguments.scheme, platform: arguments.platform, arguments: arguments.arguments + ["-showBuildSettings"])
        return try shellService.executeWithResult(arguments: arguments)
    }

    func test(with arguments: TestArguments) throws {
        let arguments = try makeArguments(from: arguments)
        try shellService.execute(arguments: arguments)
    }

    private func makeArguments(from arguments: TestArguments) throws -> [String] {
        var additionalArguments = ["test"]
        if let testPlan = arguments.testPlan {
            additionalArguments += ["-testPlan", testPlan]
        }
        if arguments.isCodeCoverageEnabled {
            additionalArguments += ["-enableCodeCoverage", "YES"]
        }
        return try makeArguments(scheme: arguments.scheme, platform: arguments.platform, arguments: additionalArguments)
    }

    private func makeArguments(scheme: String, platform: Platform?, arguments: [String]) throws -> [String] {
        var buildArguments = ["xcodebuild", "-scheme", scheme]
        if let platform = platform {
            let destination = try getDestination(for: platform, scheme: scheme)
            buildArguments += ["-destination", destination]
        }
        if !verboseController.isVerbose() {
            buildArguments += ["-quiet"]
        }
        return buildArguments + arguments
    }

    private func getDestination(for platform: Platform, scheme: String) throws -> String {
        let key = getKey(for: platform)
        let id = try getDeviceId(for: key, scheme: scheme)
        return getDestinationString(for: platform, with: id)
    }

    private func getDeviceId(for key: String, scheme: String) throws -> String {
        let destinations = try shellService.executeWithResult(arguments: ["xcodebuild", "-scheme", scheme, "-showdestinations", "-quiet"])
        printService.printVerbose(destinations)
        let components = destinations
            .components(separatedBy: "\n")
        let destination = try components.first(where: { $0.contains(key) }) ?!+ "no key"
        let attributes = destination.split(separator: " ")
        let idKeyValue = try attributes.first(where: { $0.starts(with: "id:") }) ?!+ "missing id"
        let id = idKeyValue.dropFirst(3)
        printService.printVerbose("Selecting device with id: \(id), for key: \(key)")
        return String(id)
    }

    private func getKey(for platform: Platform) -> String {
        switch platform {
        case .iOS:
            return "platform:iOS Simulator"
        case .macOS:
            return "variant:Mac Catalyst"
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

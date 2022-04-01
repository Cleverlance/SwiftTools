//
//  File.swift
//  
//
//  Created by Jan Halousek on 01.04.2022.
//

import Foundation

public protocol BuildInteractor {
    func build(with arguments: [String]) throws
    func test(with arguments: [String]) throws
    func getDeviceId(for platform: Platform) throws -> String
}

final class BuildInteractorImpl: BuildInteractor {
    private let shellService: ShellService
    private let printService: PrintService

    init(shellService: ShellService, printService: PrintService) {
        self.shellService = shellService
        self.printService = printService
    }

    func build(with arguments: [String]) throws {
        try shellService.execute(arguments: ["xcodebuild"] + arguments)
    }

    func test(with arguments: [String]) throws {
        try shellService.execute(arguments: ["xcodebuild", "test"] + arguments)
    }

    func getDeviceId(for platform: Platform) throws -> String {
        let key = getKey(for: platform)
        let destinations = try shellService.executeWithResult(arguments: ["xcodebuild", "-scheme", "Individual", "-showdestinations", "-quiet"])
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
}

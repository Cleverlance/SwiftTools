//
//  File.swift
//
//
//  Created by Jan Halousek on 08.01.2021.
//

import Foundation

public protocol UpdateInteractor {
    func updateTools() throws
    func updateXcodeSelect() throws
}

final class UpdateInteractorImpl: UpdateInteractor {
    private let shellService: ShellService
    private let configurationController: ConfigurationController
    private let fileService: LocalFileService

    init(shellService: ShellService, configurationController: ConfigurationController, fileService: LocalFileService) {
        self.shellService = shellService
        self.configurationController = configurationController
        self.fileService = fileService
    }

    func updateTools() throws {
        let path = configurationController.getUpdatePath()
        try shellService.execute(arguments: [".\(path)"])
    }

    func updateXcodeSelect() throws {
        let xcodePath = try getXcodePath()
        try shellService.execute(arguments: ["sudo", "-S", "xcode-select", "-s", "\"\(xcodePath)\""])
    }

    private func getXcodePath() throws -> String {
        let path = fileService.getCurrentPath() + "/" + configurationController.getXcodeConfigurationPath()
        return try fileService.readFile(at: path)
    }
}

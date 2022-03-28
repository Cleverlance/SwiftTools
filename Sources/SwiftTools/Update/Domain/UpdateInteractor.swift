//
//  File.swift
//
//
//  Created by Jan Halousek on 08.01.2021.
//

import Foundation

public protocol UpdateInteractor {
    func execute() throws
}

final class UpdateInteractorImpl: UpdateInteractor {
    private let shellService: ShellService
    private let configurationController: ConfigurationController

    init(shellService: ShellService, configurationController: ConfigurationController) {
        self.shellService = shellService
        self.configurationController = configurationController
    }

    public func execute() throws {
        let path = configurationController.getUpdatePath()
        try shellService.execute(arguments: [".\(path)"])
    }
}

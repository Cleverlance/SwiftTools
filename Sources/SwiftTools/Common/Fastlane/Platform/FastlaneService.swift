//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

public protocol FastlaneService {
    func execute(arguments: [String]) throws
}

final class FastlaneServiceImpl: FastlaneService {
    private let shellService: ShellService
    private let configurationController: ConfigurationController
    private var isInstallExecuted = false

    init(shellService: ShellService, configurationController: ConfigurationController) {
        self.shellService = shellService
        self.configurationController = configurationController
    }

    func execute(arguments: [String]) throws {
        if !isInstallExecuted {
            try shellService.execute(arguments: ["bundle", "install"])
            isInstallExecuted = true
        }

        let fastlaneArguments = ["bundle", "exec", "fastlane"] + arguments
        try shellService.execute(arguments: fastlaneArguments)
    }
}

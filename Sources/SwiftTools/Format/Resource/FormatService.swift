//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Foundation
import SwiftFormat

public protocol FormatService {
    func format(path: String) throws
}

final class FormatServiceImpl: FormatService {
    private let printService: PrintService
    private let localFileService: LocalFileService
    private let configurationController: ConfigurationController
    private let verboseController: VerboseController

    init(
        printService: PrintService,
        localFileService: LocalFileService,
        configurationController: ConfigurationController,
        verboseController: VerboseController
    ) {
        self.printService = printService
        self.localFileService = localFileService
        self.configurationController = configurationController
        self.verboseController = verboseController
    }

    func format(path: String) throws {
        CLI.print = { [weak self] text, type in
            switch type {
            case .error, .warning:
                self?.printService.printText("\(type): \(text)")
            case .info, .success, .content, .raw:
                self?.printService.printVerbose("\(type): \(text)")
            }
        }
        let currentPath = localFileService.getCurrentPath()
        let configurationFilePath = configurationController.getSwiftFormatConfigurationFilePath()
        let verboseText = verboseController.isVerbose() ? " --verbose" : ""
        let result = CLI.run(in: currentPath, with: "\(path) --config \(configurationFilePath)\(verboseText)")

        if result != .ok {
            throw ToolsError(description: "Formatting failed with exit code: \(result)")
        }
    }
}

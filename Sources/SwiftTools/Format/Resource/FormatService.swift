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

    init(printService: PrintService, localFileService: LocalFileService, configurationController: ConfigurationController) {
        self.printService = printService
        self.localFileService = localFileService
        self.configurationController = configurationController
    }

    func format(path: String) throws {
        CLI.print = { [weak self] text, type in
            switch type {
            case .error, .warning:
                self?.printService.printText("\(type): \(text)")
            case .info, .success, .content, .raw:
                break
            }
        }
        let currentPath = localFileService.getCurrentPath()
        let configurationFilePath = configurationController.getSwiftFormatConfigurationFilePath()
        let result = CLI.run(in: currentPath, with: "\(path) --config \(configurationFilePath) --swiftversion 5")

        if result != .ok {
            throw ToolsError(description: "Formatting failed with exit code: \(result)")
        }
    }
}

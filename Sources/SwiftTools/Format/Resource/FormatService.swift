//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Foundation
import SwiftFormat

public struct FormatSettings {
    public let currentPath: String
    public let path: String
    public let configPath: String

    public init(currentPath: String, path: String, configPath: String) {
        self.currentPath = currentPath
        self.path = path
        self.configPath = configPath
    }
}

public protocol FormatService {
    func format(with settings: FormatSettings) throws
}

final class FormatServiceImpl: FormatService {
    private let printService: PrintService

    init(printService: PrintService) {
        self.printService = printService
    }

    func format(with settings: FormatSettings) throws {
        CLI.print = { [weak self] text, type in
            switch type {
            case .error, .warning:
                self?.printService.printText("\(type): \(text)")
            case .info, .success, .content, .raw:
                break
            }
        }
        let currentPath = settings.currentPath
        let result = CLI.run(in: currentPath, with: "\(settings.path) --config \(settings.configPath) --swiftversion 5")

        if result != .ok {
            throw ToolsError(description: "Formatting failed with exit code: \(result)")
        }
    }
}

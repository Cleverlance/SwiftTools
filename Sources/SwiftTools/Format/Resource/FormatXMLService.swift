//
//  File.swift
//
//
//  Created by Jan Halousek on 25.06.2021.
//

import Foundation

public protocol FormatXMLService {
    func format(path: String) throws
}

final class FormatXMLServiceImpl: FormatXMLService {
    private let shellService: ShellService

    init(shellService: ShellService) {
        self.shellService = shellService
    }

    func format(path: String) throws {
        try shellService.execute(arguments: ["XMLLINT_INDENT='    '", "xmllint", "-o", path, "--format", path])
    }
}

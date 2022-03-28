//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

public struct ToolsError: Error {
    public let description: String

    public init(description: String) {
        self.description = description
    }
}

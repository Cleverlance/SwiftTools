//
//  File.swift
//  
//
//  Created by Jan Halousek on 19.04.2022.
//

import Foundation

public protocol SlackErrorConverter {
    func makeMessage(from error: Error) -> String
}

final class SlackErrorConverterImpl: SlackErrorConverter {
    func makeMessage(from error: Error) -> String {
        let message = (error as? ToolsError)?.description ?? error.localizedDescription
        return message.replacingOccurrences(of: "\"", with: "'")
    }
}

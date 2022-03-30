//
//  File.swift
//
//
//  Created by Kryštof Matěj on 29.03.2022.
//

import Foundation

public protocol JsonSerializer {
    func serialize(object: Any) throws -> String
}

final class JsonSerializerImpl: JsonSerializer {
    func serialize(object: Any) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
        return String(data: data, encoding: .utf8) ?? ""
    }
}

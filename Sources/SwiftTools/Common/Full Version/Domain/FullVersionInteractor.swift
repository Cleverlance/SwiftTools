//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 02.08.2021.
//

public protocol FullVersionFormatter {
    func format(version: String) -> String
}

final class FullVersionFormatterImpl: FullVersionFormatter {
    func format(version: String) -> String {
        var parts = version.split(separator: ".")

        if parts.count > 3 {
            parts = Array(parts[0 ..< 3])
        }

        for _ in 0 ..< 3 - parts.count {
            parts.append("0")
        }

        return parts.joined(separator: ".")
    }
}

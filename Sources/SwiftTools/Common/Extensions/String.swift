//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 10.08.2021.
//

import Foundation

public extension String {
    func trim() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }

    func inset() -> String {
        return "    " + self
    }

    var utf8Data: Data {
        return Data(utf8)
    }
}

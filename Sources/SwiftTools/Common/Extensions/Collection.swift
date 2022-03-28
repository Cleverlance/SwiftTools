//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 10.08.2021.
//

public extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

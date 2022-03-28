//
//  File.swift
//  File
//
//  Created by Jan Halousek on 25.08.2021.
//

public func + <Key, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach { result[$0] = $1 }
    return result
}

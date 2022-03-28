//
//  File.swift
//
//
//  Created by Kryštof Matěj on 07.01.2021.
//

infix operator ?!+: NilCoalescingPrecedence
public func ?!+ <A>(lhs: A?, rhs: String) throws -> A {
    guard let value = lhs else {
        throw ToolsError(description: rhs)
    }
    return value
}

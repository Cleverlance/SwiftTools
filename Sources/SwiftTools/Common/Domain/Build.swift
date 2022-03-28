//
//  File.swift
//
//
//  Created by Kryštof Matěj on 03.02.2021.
//

public struct Build {
    public let version: String
    public let number: Int

    public init(version: String, number: Int) {
        self.version = version
        self.number = number
    }
}

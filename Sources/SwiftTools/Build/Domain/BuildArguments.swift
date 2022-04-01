//
//  File.swift
//  
//
//  Created by Jan Halousek on 01.04.2022.
//

public struct BuildArguments {
    public let scheme: String
    public let platform: Platform?
    public let arguments: [String]

    public init(scheme: String, platform: Platform?, arguments: [String] = []) {
        self.scheme = scheme
        self.platform = platform
        self.arguments = arguments
    }
}

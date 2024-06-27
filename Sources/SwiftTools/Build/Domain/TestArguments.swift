//
//  File.swift
//  
//
//  Created by Jan Halousek on 01.04.2022.
//

public struct TestArguments {
    public let scheme: String
    public let platform: Platform
    public let testPlan: String?
    public let isCodeCoverageEnabled: Bool
    public let isQuiet: Bool
    public let skipMacroValidation: Bool

    public init(
        scheme: String,
        platform: Platform,
        testPlan: String? = nil,
        isCodeCoverageEnabled: Bool = false,
        isQuiet: Bool = true,
        skipMacroValidation: Bool = false
    ) {
        self.scheme = scheme
        self.platform = platform
        self.testPlan = testPlan
        self.isCodeCoverageEnabled = isCodeCoverageEnabled
        self.isQuiet = isQuiet
        self.skipMacroValidation = skipMacroValidation
    }
}

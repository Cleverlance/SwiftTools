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

    public init(scheme: String, platform: Platform, testPlan: String? = nil, isCodeCoverageEnabled: Bool = false) {
        self.scheme = scheme
        self.platform = platform
        self.testPlan = testPlan
        self.isCodeCoverageEnabled = isCodeCoverageEnabled
    }
}

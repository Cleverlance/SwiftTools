//
//  File.swift
//
//
//  Created by Jan Halousek on 02.06.2021.
//

import Foundation

public struct SlackConfiguration {
    public let url: URL
    public let mergeIconPath: String
    public let channel: String

    public init(url: URL, mergeIconPath: String, channel: String) {
        self.url = url
        self.mergeIconPath = mergeIconPath
        self.channel = channel
    }
}

public protocol ConfigurationController {
    func getSlackConfiguration() -> SlackConfiguration
    func getUpdatePath() -> String
    func getXcodeConfigurationPath() -> String
    func getSwiftFormatConfigurationFilePath() -> String
}

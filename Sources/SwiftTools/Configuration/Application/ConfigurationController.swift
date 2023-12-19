//
//  File.swift
//
//
//  Created by Jan Halousek on 02.06.2021.
//

import Foundation

public protocol ConfigurationController {
    func getUpdatePath() -> String
    func getXcodeConfigurationPath() -> String
    func getSwiftFormatConfigurationFilePath() -> String
}

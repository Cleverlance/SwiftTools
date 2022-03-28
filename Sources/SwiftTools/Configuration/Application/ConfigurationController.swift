//
//  File.swift
//
//
//  Created by Jan Halousek on 02.06.2021.
//

public protocol ConfigurationController {
    func getSlackUrl() -> String
    func getSlackMergeIconPath() -> String
    func getUpdatePath() -> String
}

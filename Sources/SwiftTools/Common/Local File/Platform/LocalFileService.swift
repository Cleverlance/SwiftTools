//
//  File.swift
//
//
//  Created by Jan Halousek on 12.01.2021.
//

import Foundation

public protocol LocalFileService {
    func getCurrentPath() -> String
    func getLibraryPath() throws -> String
    func removeItem(at path: String) throws
    func fileExists(at path: String) -> Bool
    func copyItem(atPath: String, toPath: String) throws
    func createDirectory(at path: String) throws
    func write(data: Data, to path: String) throws
    func getListOfItem(at path: String) throws -> [String]
    func readFile(at path: String) throws -> String
}

final class LocalFileServiceImpl: LocalFileService {
    private lazy var fileManager: FileManager = .default

    func getCurrentPath() -> String {
        return fileManager.currentDirectoryPath
    }

    func getLibraryPath() throws -> String {
        return try fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first?.path ?!+ "Library url not found"
    }

    func removeItem(at path: String) throws {
        try fileManager.removeItem(atPath: path)
    }

    func fileExists(at path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    func copyItem(atPath: String, toPath: String) throws {
        try fileManager.copyItem(atPath: atPath, toPath: toPath)
    }

    func createDirectory(at path: String) throws {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }

    func write(data: Data, to path: String) throws {
        let url = try URL(fileURLWithPath: path) ?!+ "Invalid path"
        try data.write(to: url)
    }

    func getListOfItem(at path: String) throws -> [String] {
        return try fileManager.contentsOfDirectory(atPath: path)
    }

    func readFile(at path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url) ?!+ "Invalid url"
        return try String(data: data, encoding: .utf8) ?!+ "Invalid encoding"
    }
}

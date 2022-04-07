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
    func isFileExists(at path: String) -> Bool
    func copyItem(atPath source: String, toPath destination: String) throws
    func createDirectory(at path: String) throws
    func write(data: Data, to path: String) throws
    func getListOfItems(at path: String) throws -> [String]
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
        let url = makeNormalizedUrl(path: path)
        try fileManager.removeItem(at: url)
    }

    func isFileExists(at path: String) -> Bool {
        let url = makeNormalizedUrl(path: path)
        return fileManager.fileExists(atPath: url.path)
    }

    func copyItem(atPath source: String, toPath destination: String) throws {
        let source = makeNormalizedUrl(path: source)
        let destination = makeNormalizedUrl(path: destination)
        try fileManager.copyItem(at: source, to: destination)
    }

    func createDirectory(at path: String) throws {
        let url = makeNormalizedUrl(path: path)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func write(data: Data, to path: String) throws {
        let url = makeNormalizedUrl(path: path)
        try data.write(to: url)
    }

    func getListOfItems(at path: String) throws -> [String] {
        let url = makeNormalizedUrl(path: path)
        return try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).map(\.path)
    }

    func readFile(at path: String) throws -> String {
        let url = makeNormalizedUrl(path: path)
        let data = try Data(contentsOf: url) ?!+ "Invalid url"
        return try String(data: data, encoding: .utf8) ?!+ "Invalid encoding"
    }

    private func makeNormalizedUrl(path: String) -> URL {
        guard path != "~" else {
            return FileManager.default.homeDirectoryForCurrentUser
        }
        guard path.hasPrefix("~/") else {
            return URL(fileURLWithPath: path)
        }

        var relativePath = path
        relativePath.removeFirst(2)
        return URL(fileURLWithPath: relativePath, relativeTo: FileManager.default.homeDirectoryForCurrentUser)
    }
}

//
//  File.swift
//
//
//  Created by Jan Halousek on 12.01.2021.
//

import Foundation

public typealias Path = String

public protocol LocalFileService {
    func getCurrentPath() -> String
    func getLibraryPath() throws -> String
    func removeItem(at path: Path) throws
    func isItemPresent(at path: Path) -> Bool
    func copyItem(atPath source: Path, toPath destination: Path) throws
    func createDirectory(at path: Path) throws
    func write(data: Data, to path: Path) throws
    func getListOfItems(at path: Path) throws -> [Path]
    func readFile(at path: Path) throws -> String
}

final class LocalFileServiceImpl: LocalFileService {
    private lazy var fileManager: FileManager = .default

    func getCurrentPath() -> String {
        return fileManager.currentDirectoryPath
    }

    func getLibraryPath() throws -> String {
        return try fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first?.path ?!+ "Library url not found"
    }

    func removeItem(at path: Path) throws {
        let url = makeNormalizedUrl(path: path)
        try fileManager.removeItem(at: url)
    }

    func isItemPresent(at path: Path) -> Bool {
        let url = makeNormalizedUrl(path: path)
        return fileManager.fileExists(atPath: url.path)
    }

    func copyItem(atPath source: Path, toPath destination: Path) throws {
        let source = makeNormalizedUrl(path: source)
        let destination = makeNormalizedUrl(path: destination)
        try fileManager.copyItem(at: source, to: destination)
    }

    func createDirectory(at path: Path) throws {
        let url = makeNormalizedUrl(path: path)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func write(data: Data, to path: Path) throws {
        let url = makeNormalizedUrl(path: path)
        try data.write(to: url)
    }

    func getListOfItems(at path: Path) throws -> [String] {
        let url = makeNormalizedUrl(path: path)
        return try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).map(\.path)
    }

    func readFile(at path: Path) throws -> String {
        let url = makeNormalizedUrl(path: path)
        let data = try Data(contentsOf: url) ?!+ "Invalid url"
        return try String(data: data, encoding: .utf8) ?!+ "Invalid encoding"
    }

    private func makeNormalizedUrl(path: Path) -> URL {
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

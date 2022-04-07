//
//  File.swift
//
//
//  Created by Kryštof Matěj on 07.04.2022.
//

import Foundation
@testable import SwiftTools
import XCTest

class LocalFileServiceTests: XCTestCase {
    let testFolder = "~/unit_test_folder/"
    var sut: LocalFileServiceImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocalFileServiceImpl()
        try sut.createDirectory(at: testFolder)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try sut.removeItem(at: testFolder)
    }

    func test_whenGetCurrentPath_thenReturnPath() {
        let path = sut.getCurrentPath()

        XCTAssert(!path.isEmpty)
    }

    func test_whenGetLibraryPath_thenReturnPath() throws {
        let path = try sut.getLibraryPath()

        XCTAssert(path.hasPrefix("/Users/"))
        XCTAssert(path.hasSuffix("/Library"))
    }

    func test_whenIsFileExists_thenReturnFalse() {
        let isExists = sut.isItemPresent(at: testFolder + "a/b/c/data.txt")

        XCTAssertEqual(isExists, false)
    }

    func test_givenCreateFoldersAndWriteFile_whenIsFileExists_thenReturnTrue() throws {
        try sut.createDirectory(at: testFolder + "a/b/c/")
        try sut.write(data: "data".utf8Data, to: testFolder + "a/b/c/data.txt")

        let isExists = sut.isItemPresent(at: testFolder + "a/b/c/data.txt")

        XCTAssertEqual(isExists, true)
    }

    func test_givenCreateFoldersAndRemoveIt_whenIsFileExists_thenReturnFalse() throws {
        try sut.createDirectory(at: testFolder + "a/b/c/")
        try sut.removeItem(at: testFolder + "a")

        let isExists = sut.isItemPresent(at: testFolder + "a/b/c/data.txt")

        XCTAssertEqual(isExists, false)
    }

    func test_givenWriteFile_whenReadFile_thenReturnFileContent() throws {
        try sut.write(data: "text".utf8Data, to: testFolder + "data.txt")

        let content = try sut.readFile(at: testFolder + "data.txt")

        XCTAssertEqual(content, "text")
    }

    func test_givenWriteFileAndCopy_whenGetListOfItems_thenReturnItems() throws {
        try sut.write(data: "text".utf8Data, to: testFolder + "data.txt")
        try sut.copyItem(atPath: testFolder + "data.txt", toPath: testFolder + "copy.txt")

        let list = try sut.getListOfItems(at: testFolder)

        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list[safe: 0]?.hasSuffix(testFolder.replacingOccurrences(of: "~/", with: "") + "copy.txt"), true)
        XCTAssertEqual(list[safe: 1]?.hasSuffix(testFolder.replacingOccurrences(of: "~/", with: "") + "data.txt"), true)
    }
}

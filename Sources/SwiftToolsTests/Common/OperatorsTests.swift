//
//  File.swift
//  
//
//  Created by Jan Halousek on 29.03.2022.
//

import SwiftTools
import XCTest

final class OperatorsTests: XCTestCase {
    func test_whenUseThrowingOperator_thenErrorIsThrown() {
        XCTAssertThrowsError(try throwError()) { error in
            let error = error as? ToolsError
            XCTAssertEqual(error?.description, "Custom text")
        }
    }

    private func throwError() throws {
        let optional: String? = nil
        _ = try optional ?!+ "Custom text"
    }
}

enum TestsError: Error {
    case stub
}

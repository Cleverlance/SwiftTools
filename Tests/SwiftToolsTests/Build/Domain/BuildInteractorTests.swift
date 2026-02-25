//
//  BuildInteractorTests.swift
//  
//
//  Created by Kryštof Matěj on 29.09.2022.
//

@testable import SwiftTools
import XCTest

final class BuildInteractorTests: XCTestCase {
    private var shellServiceSpy: ShellServiceSpy!
    private var printServiceSpy: PrintServiceSpy!
    private var verboseControllerSpy: VerboseControllerSpy!
    private var getSimulatorIdUseCaseSpy: GetSimulatorIdUseCaseSpy!
    private var sut: BuildInteractorImpl!

    override func setUp() {
        super.setUp()
        shellServiceSpy = ShellServiceSpy(executeWithResultReturn: "")
        printServiceSpy = PrintServiceSpy()
        verboseControllerSpy = VerboseControllerSpy(isVerboseReturn: false)
        getSimulatorIdUseCaseSpy = GetSimulatorIdUseCaseSpy(callAsFunctionReturn: "")
        sut = BuildInteractorImpl(
            shellService: shellServiceSpy,
            printService: printServiceSpy,
            verboseController: verboseControllerSpy,
            getSimulatorId: getSimulatorIdUseCaseSpy
        )
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

final class ShellServiceSpy: ShellService {
    struct Execute {
        let arguments: [String]
    }

    struct ExecuteWithVisibleOutput {
        let arguments: [String]
    }

    struct ExecuteWithResult {
        let arguments: [String]
    }

    struct ExecuteWithXCBeautify {
        let arguments: [String]
    }

    var executeThrowBlock: (() throws -> Void)?
    var executeWithVisibleOutputThrowBlock: (() throws -> Void)?
    var executeWithResultThrowBlock: (() throws -> Void)?
    var executeWithResultReturn: String
    var executeWithXCBeautifyThrowBlock: (() throws -> Void)?
    var execute = [Execute]()
    var executeWithVisibleOutput = [ExecuteWithVisibleOutput]()
    var executeWithResult = [ExecuteWithResult]()
    var executeWithXCBeautify = [ExecuteWithXCBeautify]()

    init(executeWithResultReturn: String) {
        self.executeWithResultReturn = executeWithResultReturn
    }

    func execute(arguments: [String]) throws {
        let item = Execute(arguments: arguments)
        execute.append(item)
        try executeThrowBlock?()
    }

    func executeWithVisibleOutput(arguments: [String]) throws {
        let item = ExecuteWithVisibleOutput(arguments: arguments)
        executeWithVisibleOutput.append(item)
        try executeWithVisibleOutputThrowBlock?()
    }

    func executeWithResult(arguments: [String]) throws -> String {
        let item = ExecuteWithResult(arguments: arguments)
        executeWithResult.append(item)
        try executeWithResultThrowBlock?()
        return executeWithResultReturn
    }

    func executeWithXCBeautify(arguments: [String]) throws {
        let item = ExecuteWithXCBeautify(arguments: arguments)
        executeWithXCBeautify.append(item)
        try executeWithXCBeautifyThrowBlock?()
    }
}

final class PrintServiceSpy: PrintService {

    struct PrintText {
        let text: String
    }

    struct PrintVerbose {
        let text: String
    }

    var printText = [PrintText]()
    var printVerbose = [PrintVerbose]()

    func printText(_ text: String) {
        let item = PrintText(text: text)
        printText.append(item)
    }

    func printVerbose(_ text: String) {
        let item = PrintVerbose(text: text)
        printVerbose.append(item)
    }
}

final class VerboseControllerSpy: VerboseController {

    var setVerboseCount = 0
    var isVerboseCount = 0
    var isVerboseReturn: Bool

    init(isVerboseReturn: Bool) {
        self.isVerboseReturn = isVerboseReturn
    }

    func setVerbose() {
        setVerboseCount += 1
    }

    func isVerbose() -> Bool {
        isVerboseCount += 1
        return isVerboseReturn
    }
}

extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.endIndex > endIndex {
            if range.startIndex >= endIndex {return nil}
            else {return self[range.startIndex..<endIndex]}
        }
        else {
            return self[range]
        }
    }
}

final class GetSimulatorIdUseCaseSpy: GetSimulatorIdUseCase {
    struct CallAsFunction {
        let platform: Platform
        let scheme: String
    }

    var callAsFunctionThrowBlock: (() throws -> Void)?
    var callAsFunctionReturn: String
    var callAsFunction = [CallAsFunction]()

    init(callAsFunctionReturn: String) {
        self.callAsFunctionReturn = callAsFunctionReturn
    }

    func callAsFunction(for platform: Platform, scheme: String) throws -> String {
        let item = CallAsFunction(platform: platform, scheme: scheme)
        callAsFunction.append(item)
        try callAsFunctionThrowBlock?()
        return callAsFunctionReturn
    }
}

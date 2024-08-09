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
    private var sut: BuildInteractorImpl!

    override func setUp() {
        super.setUp()
        shellServiceSpy = ShellServiceSpy(executeWithResultReturn: "")
        shellServiceSpy.executeWithResultReturn = """
        --- xcodebuild: WARNING: Using the first of multiple matching destinations:
        { platform:macOS, arch:x86_64, id:B717F26A-6C7A-5DE6-A1D0-9D0374071FD0 }
        { platform:macOS, arch:x86_64, variant:Mac Catalyst, id:B717F26A-6C7A-5DE6-A1D0-9D0374071FD0 }
        { platform:macOS, arch:x86_64, variant:DriverKit, id:B717F26A-6C7A-5DE6-A1D0-9D0374071FD0 }
        { platform:DriverKit, name:Any DriverKit Host }
        { platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device }
        { platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, name:Any iOS Simulator Device }
        { platform:macOS, name:Any Mac }
        { platform:macOS, variant:Mac Catalyst, name:Any Mac }
        { platform:tvOS, id:dvtdevice-DVTiOSDevicePlaceholder-appletvos:placeholder, name:Any tvOS Device, error:tvOS 16.0 is not installed. To use with Xcode, first download and install the platform }
        { platform:watchOS, id:dvtdevice-DVTiOSDevicePlaceholder-watchos:placeholder, name:Any watchOS Device }
        { platform:watchOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-watchsimulator:placeholder, name:Any watchOS Simulator Device }
        { platform:iOS, id:00008101-001864280E00001E, name:Kryštof - iPhone }
        { platform:iOS, id:00008101-001864280E00001E, name:Kryštof - iPhone }
        { platform:watchOS Simulator, id:51C4E916-A952-4BD1-80E4-43F7AC099132, OS:9.0, name:Apple Watch SE (44mm) (2nd generation) }
        { platform:watchOS Simulator, id:BCDD1AB0-DA4E-4B0B-B3F8-9ECDEE5BB51D, OS:9.0, name:Apple Watch Series 5 - 40mm }
        { platform:watchOS Simulator, id:BFB55B67-5033-4338-9B3A-A17B19FC912C, OS:9.0, name:Apple Watch Series 5 - 44mm }
        { platform:watchOS Simulator, id:267B735F-5FBB-4696-B129-45AA952407FE, OS:9.0, name:Apple Watch Series 6 - 40mm }
        { platform:watchOS Simulator, id:DDE602D0-1179-48F6-8682-1D7295BD36F7, OS:9.0, name:Apple Watch Series 6 - 44mm }
        { platform:watchOS Simulator, id:AC36B48D-0A3E-4FE3-9B46-BCF8D02757B7, OS:9.0, name:Apple Watch Series 7 - 41mm }
        { platform:watchOS Simulator, id:2E4044E3-D43B-4C07-9D9D-2D425B158CE0, OS:9.0, name:Apple Watch Series 7 - 45mm }
        { platform:watchOS Simulator, id:CD2AE6CE-B23F-4D9D-9E3A-105C70B7C7DD, OS:9.0, name:Apple Watch Series 8 (41mm) }
        { platform:watchOS Simulator, id:A7B0CF28-B1D3-47F2-8450-6CD3B6932918, OS:9.0, name:Apple Watch Series 8 (45mm) }
        { platform:watchOS Simulator, id:A67C8286-EECA-4032-9A19-DC179700EDF2, OS:9.0, name:Apple Watch Ultra (49mm) }
        { platform:iOS Simulator, id:40164398-DEA8-4D73-8813-CF7B2AC49090, OS:16.0, name:iPhone 14 }
        { platform:iOS Simulator, id:65B8DC87-F312-43F3-8C72-06E490AD6F63, OS:16.0, name:iPhone 14 Plus }
        { platform:iOS Simulator, id:A5AAC58E-85CE-4979-8BE1-AE12856A89EE, OS:16.0, name:iPhone 14 Pro }
        { platform:iOS Simulator, id:2D31C35E-8B10-4173-9411-DB4EF76907C8, OS:16.0, name:iPhone 14 Pro Max }
        """
        printServiceSpy = PrintServiceSpy()
        verboseControllerSpy = VerboseControllerSpy(isVerboseReturn: false)
        sut = BuildInteractorImpl(shellService: shellServiceSpy, printService: printServiceSpy, verboseController: verboseControllerSpy)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_givenBuildDestinationsAndiOSPlatform_whenTest_thenParseCorrectDestination() throws {
        let argumetns = TestArguments(scheme: "scheme", platform: .iOS)

        try sut.test(with: argumetns)

        XCTAssertEqual(shellServiceSpy.executeWithXCBeautify.count, 1)
        XCTAssertEqual(shellServiceSpy.executeWithXCBeautify.last?.arguments[safe: 4], "\"platform=iOS Simulator,id=40164398-DEA8-4D73-8813-CF7B2AC49090\"")
    }

    func test_givenBuildDestinationsAndmacOSPlatform_whenTest_thenParseCorrectDestination() throws {
        let argumetns = TestArguments(scheme: "scheme", platform: .macOS)

        try sut.test(with: argumetns)

        XCTAssertEqual(shellServiceSpy.executeWithXCBeautify.count, 1)
        XCTAssertEqual(shellServiceSpy.executeWithXCBeautify.last?.arguments[safe: 4], "\"platform=macOS,variant=Mac Catalyst,id=B717F26A-6C7A-5DE6-A1D0-9D0374071FD0\"")
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

//
//  File.swift
//
//
//  Created by Jan Halousek on 18.01.2021.
//

import Foundation

public protocol CleanupInteractor {
    func execute(with paths: [String]) throws
    func removeProvisioningProfiles() throws
    func clearDerivedData() throws
    func completeCleanUp(simulatorId: String?) throws
}

final class CleanupInteractorImpl: CleanupInteractor {
    private let fileService: LocalFileService
    private let shellService: ShellService

    init(fileService: LocalFileService, shellService: ShellService) {
        self.fileService = fileService
        self.shellService = shellService
    }

    func execute(with paths: [String]) throws {
        for path in paths {
            if fileService.isItemPresent(at: path) {
                try fileService.removeItem(at: path)
            }
        }
    }

    func removeProvisioningProfiles() throws {
        let libraryPath = try fileService.getLibraryPath()
        do {
            try fileService.removeItem(at: libraryPath + "/MobileDevice/Provisioning Profiles/")
        } catch {
            // Ignore missing folder
        }
    }

    func clearDerivedData() throws {
        let libraryPath = try fileService.getLibraryPath()
        do {
            try fileService.removeItem(at: libraryPath + "/Developer/Xcode/DerivedData/")
        } catch {
            // Ignore missing folder
        }
    }

    func completeCleanUp(simulatorId: String?) throws {
        try? shellService.execute(arguments: ["killall", "Xcode"])
        try? shellService.execute(arguments: ["killall", "xcodebuild"])
        try? shellService.execute(arguments: ["killall", "xcbuild"])
        try? shellService.execute(arguments: ["killall", "swift"])
        try clearDerivedData()
        let libraryPath = try fileService.getLibraryPath()
        try? fileService.removeItem(at: libraryPath + "/Caches/org.swift.swiftpm")
        try? fileService.removeItem(at: libraryPath + "/Developer/Xcode/SourcePackages")
        try? fileService.removeItem(at: libraryPath + "/Logs/CoreSimulator")
        try? shellService.execute(arguments: ["xcrun", "simctl", "shutdown", "all"])
        try? shellService.execute(arguments: ["xcrun", "simctl", "erase", "all"])

        if let simulatorId {
            try? shellService.execute(arguments: ["xcrun", "simctl", "boot", simulatorId])
        }
    }
}

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
}

final class CleanupInteractorImpl: CleanupInteractor {
    private let fileService: LocalFileService

    init(fileService: LocalFileService) {
        self.fileService = fileService
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
}

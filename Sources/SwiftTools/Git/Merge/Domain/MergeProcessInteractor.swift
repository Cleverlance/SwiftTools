//
//  File.swift
//
//
//  Created by Jan Halousek on 19.01.2021.
//

public protocol MergeProcessInteractor {
    func mergeLocally(source: String, sourceHash: String, destination: String) throws
    func testAndPush(destination: String) throws
}

final class MergeProcessInteractorImpl: MergeProcessInteractor {
    private let gitService: GitService
    private let shellService: ShellService
    private let cleanupInteractor: CleanupInteractor
    private let testsInteractor: MergeProcessTestsInteractor

    init(gitService: GitService, shellService: ShellService, cleanupInteractor: CleanupInteractor, testsInteractor: MergeProcessTestsInteractor) {
        self.gitService = gitService
        self.shellService = shellService
        self.cleanupInteractor = cleanupInteractor
        self.testsInteractor = testsInteractor
    }

    func testAndPush(destination: String) throws {
        try testsInteractor.execute()
        try gitService.push(to: destination)
    }

    func mergeLocally(source: String, sourceHash: String, destination: String) throws {
        try gitService.run(commands: ["reset", "--hard", "HEAD"])
        try gitService.updateSubmodule()
        try gitService.merge(from: sourceHash)
        try gitService.commit(with: "Automatic merge from \(source) to \(destination)")
    }
}

//
//  File.swift
//
//
//  Created by Jan Halousek on 23.03.2022.
//

import Foundation

public protocol SynchronizeLatestReleaseInteractor {
    func execute(currentBranch: String) throws
}

final class SynchronizeLatestReleaseInteractorImpl: SynchronizeLatestReleaseInteractor {
    private let branchesInteractor: GitBranchesInteractor
    private let gitService: GitService

    init(branchesInteractor: GitBranchesInteractor, gitService: GitService) {
        self.branchesInteractor = branchesInteractor
        self.gitService = gitService
    }

    func execute(currentBranch: String) throws {
        guard let source = try branchesInteractor.getReleaseBranches().last else {
            throw ToolsError(description: "Cannot find any release branches")
        }

        try gitService.checkout(source.name)
        try gitService.pull()
        try gitService.checkout(currentBranch)
        try gitService.rebase(onto: "origin/\(source.name)")
        try gitService.forcePush(to: currentBranch)
    }
}

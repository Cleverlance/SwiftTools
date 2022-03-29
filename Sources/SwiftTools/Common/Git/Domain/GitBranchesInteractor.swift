//
//  File.swift
//
//
//  Created by Jan Halousek on 09.11.2021.
//

import Foundation

public struct Branch: Hashable {
    public let name: String
    public let majorVersion: UInt
    public let minorVersion: UInt
    public let patchVersion: UInt

    public init(name: String, majorVersion: UInt, minorVersion: UInt, patchVersion: UInt) {
        self.name = name
        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
        self.patchVersion = patchVersion
    }
}

public protocol GitBranchesInteractor {
    func getReleaseBranches() throws -> [Branch]
}

final class GitBranchesInteractorImpl: GitBranchesInteractor {
    private let gitService: GitService

    init(gitService: GitService) {
        self.gitService = gitService
    }

    func getReleaseBranches() throws -> [Branch] {
        let branches = try gitService.getRemoteBranches().compactMap(makeBranch(from:))
        let releaseBranches = Set(branches.filter(isReleaseBranch(branch:)))
        return sortReleaseBranches(branches: releaseBranches)
    }

    private func isReleaseBranch(branch: Branch) -> Bool {
        let isDevelopmentBranch = branch.name.split(separator: "/").count == 2
        return isDevelopmentBranch && (branch.name.hasSuffix("/develop") || branch.name.hasSuffix("/release"))
    }

    private func makeBranch(from string: String) -> Branch? {
        guard let version = string.components(separatedBy: "/").first else {
            return nil
        }

        let versions = version.components(separatedBy: ".")

        return Branch(
            name: string,
            majorVersion: UInt(versions[safe: 0] ?? "") ?? 0,
            minorVersion: UInt(versions[safe: 1] ?? "") ?? 0,
            patchVersion: UInt(versions[safe: 2] ?? "") ?? 0
        )
    }

    private func sortReleaseBranches(branches: Set<Branch>) -> [Branch] {
        branches.sorted(by: isPreceding(firstBranch:secondBranch:))
    }

    private func isPreceding(firstBranch: Branch, secondBranch: Branch) -> Bool {
        if firstBranch.majorVersion != secondBranch.majorVersion {
            return firstBranch.majorVersion < secondBranch.majorVersion
        } else if firstBranch.minorVersion != secondBranch.minorVersion {
            return firstBranch.minorVersion < secondBranch.minorVersion
        } else {
            return firstBranch.patchVersion < secondBranch.patchVersion
        }
    }
}

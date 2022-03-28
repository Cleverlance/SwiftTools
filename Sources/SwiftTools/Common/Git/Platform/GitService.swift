//
//  File.swift
//
//
//  Created by Jan Halousek on 18.01.2021.
//

import Foundation

public protocol GitService {
    func run(commands: [String]) throws
    func runWithResult(commands: [String]) throws -> String
    func resetRepository() throws
    func getRemoteBranches() throws -> Set<String>
    func pull() throws
    func push(to branchName: String) throws
    func forcePush(to branchName: String) throws
    func checkout(_ identifier: String) throws
    func updateSubmodule() throws
    func merge(from sourceHash: String) throws
    func commit(with message: String) throws
    func getStatus(with arguments: [String]) throws -> String
    func rebase(onto branchName: String) throws
}

final class GitServiceImpl: GitService {
    private let shellService: ShellService

    init(shellService: ShellService) {
        self.shellService = shellService
    }

    func run(commands: [String]) throws {
        try shellService.execute(arguments: ["git"] + commands)
    }

    func runWithResult(commands: [String]) throws -> String {
        return try shellService.executeWithResult(arguments: ["git"] + commands)
    }

    func resetRepository() throws {
        try run(commands: ["reset", "--hard", "HEAD"])
        try run(commands: ["clean", "-f", "-d"])
    }

    func getRemoteBranches() throws -> Set<String> {
        let branchesString = try runWithResult(commands: ["branch", "-r"])
        let branches = branchesString.components(separatedBy: "\n").map { $0.trim() }
        let normalizedBranches = branches.filter { !$0.isEmpty }.map(removeOrigin(fromBranch:))
        return Set(normalizedBranches)
    }

    private func removeOrigin(fromBranch branch: String) -> String {
        let components = branch.components(separatedBy: "/")
        return Array(components.dropFirst()).joined(separator: "/")
    }

    func pull() throws {
        try run(commands: ["pull"])
    }

    func push(to branchName: String) throws {
        try run(commands: ["push", "origin", branchName, "--tags"])
    }

    func forcePush(to branchName: String) throws {
        try run(commands: ["push", "--force", "origin", branchName])
    }

    func checkout(_ identifier: String) throws {
        try run(commands: ["checkout", identifier])
    }

    func updateSubmodule() throws {
        try run(commands: ["submodule", "update"])
    }

    func merge(from sourceHash: String) throws {
        try run(commands: ["merge", "--no-ff", "--no-commit", sourceHash])
    }

    func commit(with message: String) throws {
        try run(commands: ["commit", "-m", "\"\(message)\""])
    }

    func getStatus(with arguments: [String]) throws -> String {
        return try runWithResult(commands: ["diff", "--stat"] + arguments)
    }

    func rebase(onto branchName: String) throws {
        try run(commands: ["rebase", branchName])
    }
}

//
//  File.swift
//
//
//  Created by Jan Halousek on 19.01.2021.
//

import Foundation

public protocol MergeStatusInteractor {
    func execute(sourceHash: String, destination: String) throws -> String
    func executeAgainstOrigin(branchName: String) throws -> String
}

final class MergeStatusInteractorImpl: MergeStatusInteractor {
    private let gitService: GitService

    init(gitService: GitService) {
        self.gitService = gitService
    }

    func execute(sourceHash: String, destination: String) throws -> String {
        try gitService.checkout(sourceHash)
        try gitService.checkout(destination)
        try gitService.pull()
        return try gitService.getStatus(with: ["\(sourceHash)..\(destination)"])
    }

    func executeAgainstOrigin(branchName: String) throws -> String {
        return try gitService.getStatus(with: [branchName, "origin/\(branchName)"])
    }
}

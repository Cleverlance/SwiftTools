//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 10.08.2021.
//

public protocol MergeDestinationBranchInteractor {
    func getDestinationBranch(sourceBranch: String) throws -> String
}

final class MergeDestinationBranchInteractorImpl: MergeDestinationBranchInteractor {
    private let branchesInteractor: GitBranchesInteractor

    init(branchesInteractor: GitBranchesInteractor) {
        self.branchesInteractor = branchesInteractor
    }

    func getDestinationBranch(sourceBranch: String) throws -> String {
        let branches = try branchesInteractor.getReleaseBranches()

        guard let index = branches.firstIndex(where: { $0.name == sourceBranch }) else {
            throw ToolsError(description: "No source branch found")
        }

        let destinationIndex = branches.index(after: index)

        guard let destination = branches[safe: destinationIndex] else {
            throw ToolsError(description: "No destination branch found")
        }

        return destination.name
    }
}

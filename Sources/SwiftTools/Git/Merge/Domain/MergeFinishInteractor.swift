//
//  File.swift
//
//
//  Created by Jan Halousek on 29.09.2021.
//

import Foundation

public protocol MergeFinishInteractor {
    func execute(sourceBranch: String) throws
}

final class MergeFinishInteractorImpl: MergeFinishInteractor {
    private let statusInteractor: MergeStatusInteractor
    private let processInteractor: MergeProcessInteractor
    private let slackInteractor: MergeSlackInteractor
    private let printService: PrintService
    private let destinationBranchInteractor: MergeDestinationBranchInteractor

    init(statusInteractor: MergeStatusInteractor, processInteractor: MergeProcessInteractor, slackInteractor: MergeSlackInteractor, printService: PrintService, destinationBranchInteractor: MergeDestinationBranchInteractor) {
        self.statusInteractor = statusInteractor
        self.processInteractor = processInteractor
        self.slackInteractor = slackInteractor
        self.printService = printService
        self.destinationBranchInteractor = destinationBranchInteractor
    }

    func execute(sourceBranch: String) throws {
        guard let destination = try? destinationBranchInteractor.getDestinationBranch(sourceBranch: sourceBranch) else {
            printService.printText("No merge required")
            return
        }

        do {
            let status = try statusInteractor.executeAgainstOrigin(branchName: destination)
            guard !status.isEmpty else {
                return
            }
            try processInteractor.testAndPush(destination: destination)
            try slackInteractor.print(message: "Branch `\(sourceBranch)` is merged to `\(destination)`.")
        } catch {
            try slackInteractor.print(error: error)
            throw error
        }
    }
}

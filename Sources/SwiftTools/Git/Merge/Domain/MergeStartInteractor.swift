//
//  File.swift
//
//
//  Created by Jan Halousek on 18.01.2021.
//

import Foundation

public protocol MergeStartInteractor {
    func execute(sourceBranch: String, sourceHash: String) throws
}

final class MergeStartInteractorImpl: MergeStartInteractor {
    private let statusInteractor: MergeStatusInteractor
    private let processInteractor: MergeProcessInteractor
    private let slackInteractor: MergeSlackInteractor
    private let printService: PrintService
    private let destinationBranchInteractor: MergeDestinationBranchInteractor
    private let updateInteractor: UpdateInteractor

    init(statusInteractor: MergeStatusInteractor, processInteractor: MergeProcessInteractor, slackInteractor: MergeSlackInteractor, printService: PrintService, destinationBranchInteractor: MergeDestinationBranchInteractor, updateInteractor: UpdateInteractor) {
        self.statusInteractor = statusInteractor
        self.processInteractor = processInteractor
        self.slackInteractor = slackInteractor
        self.printService = printService
        self.destinationBranchInteractor = destinationBranchInteractor
        self.updateInteractor = updateInteractor
    }

    func execute(sourceBranch: String, sourceHash: String) throws {
        guard let destination = try? destinationBranchInteractor.getDestinationBranch(sourceBranch: sourceBranch) else {
            printService.printText("No merge required")
            return
        }

        do {
            let status = try statusInteractor.execute(sourceHash: sourceHash, destination: destination)
            guard !status.isEmpty else {
                return
            }
            try processInteractor.mergeLocally(source: sourceBranch, sourceHash: sourceHash, destination: destination)
            try updateInteractor.execute()
        } catch {
            try slackInteractor.print(error: error)
            throw error
        }
    }
}

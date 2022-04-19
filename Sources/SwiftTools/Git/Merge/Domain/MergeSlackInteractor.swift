//
//  File.swift
//
//
//  Created by Jan Halousek on 29.09.2021.
//

import Foundation

public protocol MergeSlackInteractor {
    func print(error: Error) throws
    func print(message: String) throws
}

final class MergeSlackInteractorImpl: MergeSlackInteractor {
    private let slackService: SlackService
    private let configurationController: ConfigurationController
    private let errorConverter: SlackErrorConverter

    init(slackService: SlackService, configurationController: ConfigurationController, errorConverter: SlackErrorConverter) {
        self.slackService = slackService
        self.configurationController = configurationController
        self.errorConverter = errorConverter
    }

    func print(error: Error) throws {
        let message = errorConverter.makeMessage(from: error)
        try print(message: "Merge failed with message: ```\(message)```", isSuccess: false)
    }

    func print(message: String) throws {
        try print(message: message, isSuccess: true)
    }

    private func print(message: String, isSuccess: Bool) throws {
        let payload = SlackPayload(message: message, username: "Merge", icon: configurationController.getSlackConfiguration().mergeIconPath, isSuccess: isSuccess)
        try slackService.print(payload: payload)
    }
}

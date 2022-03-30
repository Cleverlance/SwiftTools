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

    init(slackService: SlackService, configurationController: ConfigurationController) {
        self.slackService = slackService
        self.configurationController = configurationController
    }

    func print(error: Error) throws {
        let message = (error as? ToolsError)?.description ?? error.localizedDescription
        let cleanedMessage = message.replacingOccurrences(of: "\"", with: "'")
        try print(message: "Merge failed with message: ```\(cleanedMessage)```", isSuccess: false)
    }

    func print(message: String) throws {
        try print(message: message, isSuccess: true)
    }

    private func print(message: String, isSuccess: Bool) throws {
        let payload = SlackPayload(message: message, username: "Merge", icon: configurationController.getSlackConfiguration().mergeIconPath, isSuccess: isSuccess)
        try slackService.print(payload: payload)
    }
}

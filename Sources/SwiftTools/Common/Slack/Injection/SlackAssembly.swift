//
//  File.swift
//
//
//  Created by Jan Halousek on 13.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class SlackAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(SlackService.self, initializer: SlackServiceImpl.init)
    }
}

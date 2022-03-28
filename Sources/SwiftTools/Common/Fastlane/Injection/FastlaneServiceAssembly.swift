//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class FastlaneServiceAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(FastlaneService.self, initializer: FastlaneServiceImpl.init).inObjectScope(.container)
    }
}

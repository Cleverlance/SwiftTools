//
//  File.swift
//
//
//  Created by Kryštof Matěj on 06.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class ProjectAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(GenerateProjectService.self, initializer: GenerateProjectServiceImpl.init)
    }
}

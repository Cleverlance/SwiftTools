//
//  File.swift
//
//
//  Created by Jan Halousek on 18.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class CleanupAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(CleanupInteractor.self, initializer: CleanupInteractorImpl.init)
    }
}

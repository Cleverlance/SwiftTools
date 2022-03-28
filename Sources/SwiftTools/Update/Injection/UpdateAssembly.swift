//
//  File.swift
//
//
//  Created by Jan Halousek on 08.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class UpdateAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(UpdateInteractor.self, initializer: UpdateInteractorImpl.init)
    }
}

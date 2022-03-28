//
//  File.swift
//  
//
//  Created by Jan Halousek on 24.03.2022.
//

import Swinject

public final class SynchronizeLatestReleaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(SynchronizeLatestReleaseInteractor.self, initializer: SynchronizeLatestReleaseInteractorImpl.init)
    }
}

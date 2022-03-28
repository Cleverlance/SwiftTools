//
//  File.swift
//
//
//  Created by Jan Halousek on 18.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class MergeAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(MergeStartInteractor.self, initializer: MergeStartInteractorImpl.init)
        container.autoregister(MergeStatusInteractor.self, initializer: MergeStatusInteractorImpl.init)
        container.autoregister(MergeProcessInteractor.self, initializer: MergeProcessInteractorImpl.init)
        container.autoregister(MergeDestinationBranchInteractor.self, initializer: MergeDestinationBranchInteractorImpl.init)
        container.autoregister(MergeFinishInteractor.self, initializer: MergeFinishInteractorImpl.init)
        container.autoregister(MergeSlackInteractor.self, initializer: MergeSlackInteractorImpl.init)
    }
}

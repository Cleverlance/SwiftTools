//
//  File.swift
//
//
//  Created by Jan Halousek on 09.11.2021.
//

import Swinject
import SwinjectAutoregistration

public final class GitAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(GitService.self, initializer: GitServiceImpl.init)
        container.autoregister(GitBranchesInteractor.self, initializer: GitBranchesInteractorImpl.init)
    }
}

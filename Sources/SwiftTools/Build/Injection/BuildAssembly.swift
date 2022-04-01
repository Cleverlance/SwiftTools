//
//  File.swift
//  
//
//  Created by Jan Halousek on 01.04.2022.
//

import Swinject

public final class BuildAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(BuildInteractor.self, initializer: BuildInteractorImpl.init)
    }
}

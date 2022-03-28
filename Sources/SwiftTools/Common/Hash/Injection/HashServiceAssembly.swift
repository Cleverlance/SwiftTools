//
//  File.swift
//
//
//  Created by Jan Halousek on 12.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class HashServiceAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(HashService.self, initializer: HashServiceImpl.init)
    }
}

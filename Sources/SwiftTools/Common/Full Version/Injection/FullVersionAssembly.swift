//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 02.08.2021.
//

import Swinject
import SwinjectAutoregistration

public final class FullVersionAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(FullVersionFormatter.self, initializer: FullVersionFormatterImpl.init)
    }
}

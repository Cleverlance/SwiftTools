//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class HelpGeneratorAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(HelpGenerator.self, initializer: HelpGeneratorImpl.init)
    }
}

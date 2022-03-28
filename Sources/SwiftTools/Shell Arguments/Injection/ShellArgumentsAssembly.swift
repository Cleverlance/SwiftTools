//
//  File.swift
//
//
//  Created by Kryštof Matěj on 22.02.2021.
//

import Swinject
import SwinjectAutoregistration

public final class ShellArgumentsAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(ShellArgumentsParser.self, initializer: ShellArgumentsParserImpl.init)
    }
}

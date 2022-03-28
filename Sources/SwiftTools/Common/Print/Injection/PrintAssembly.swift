//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class PrintAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(PrintService.self, initializer: PrintServiceImpl.init)
        container.autoregister(VerboseController.self, initializer: VerboseControllerImpl.init)
    }
}

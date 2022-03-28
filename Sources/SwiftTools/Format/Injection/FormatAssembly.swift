//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class FormatAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(FormatService.self, initializer: FormatServiceImpl.init)
        container.autoregister(FormatXMLService.self, initializer: FormatXMLServiceImpl.init)
    }
}

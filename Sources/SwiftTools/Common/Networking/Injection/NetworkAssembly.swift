//
//  File.swift
//
//
//  Created by Kryštof Matěj on 07.01.2021.
//

import Swinject
import SwinjectAutoregistration

public final class NetworkAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(NetworkService.self, initializer: NetworkServiceImpl.init).inObjectScope(.transient)
    }
}

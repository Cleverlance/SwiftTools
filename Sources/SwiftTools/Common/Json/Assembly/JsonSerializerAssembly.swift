//
//  File.swift
//
//
//  Created by Kryštof Matěj on 29.03.2022.
//

import Swinject

public final class JsonSerializerAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.autoregister(JsonSerializer.self, initializer: JsonSerializerImpl.init)
    }
}

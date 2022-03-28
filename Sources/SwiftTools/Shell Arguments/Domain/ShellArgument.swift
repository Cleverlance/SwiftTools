//
//  File.swift
//
//
//  Created by Kryštof Matěj on 22.02.2021.
//

public protocol HelpableShellArgument {
    var help: ShellArgumentHelp { get }
}

public struct ShellArgumentHelp {
    public let name: String
    public let value: String
    public let isOptional: Bool
    public let description: String

    public init(name: String, value: String, isOptional: Bool, description: String) {
        self.name = name
        self.value = value
        self.isOptional = isOptional
        self.description = description
    }
}

public struct EnumShellArgument<T>: HelpableShellArgument {
    public let name: String
    public let values: [String: T]
    public let help: ShellArgumentHelp

    public init(name: String, values: [String: T], isOptional: Bool, description: String) {
        self.name = name
        self.values = values
        help = ShellArgumentHelp(
            name: name,
            value: values.keys.sorted().joined(separator: "|"),
            isOptional: isOptional,
            description: description
        )
    }
}

public struct StringShellArgument: HelpableShellArgument {
    public let name: String
    public let help: ShellArgumentHelp

    public init(name: String, isOptional: Bool, description: String) {
        self.name = name
        help = ShellArgumentHelp(
            name: name,
            value: "string",
            isOptional: isOptional,
            description: description
        )
    }

    static let appStoreConnectKeyArgument = StringShellArgument(name: "key", isOptional: true, description: "Private appstore connect key in base64. Key should be provided in tools build or as an argument")
}

public struct IntShellArgument: HelpableShellArgument {
    public let name: String
    public let help: ShellArgumentHelp

    public init(name: String, isOptional: Bool, description: String) {
        self.name = name
        help = ShellArgumentHelp(
            name: name,
            value: "int",
            isOptional: isOptional,
            description: description
        )
    }
}

public struct BoolShellArgument: HelpableShellArgument {
    public let name: String
    public let help: ShellArgumentHelp

    public init(name: String, isOptional: Bool, description: String) {
        self.name = name
        help = ShellArgumentHelp(
            name: name,
            value: "bool",
            isOptional: isOptional,
            description: description
        )
    }
}

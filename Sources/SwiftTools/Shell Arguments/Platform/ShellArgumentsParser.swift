//
//  File.swift
//
//
//  Created by Kryštof Matěj on 22.02.2021.
//

public protocol ShellArgumentsParser {
    func parseEnum<T>(argument: EnumShellArgument<T>, from arguments: [String]) throws -> T
    func parseOptionalEnum<T>(argument: EnumShellArgument<T>, from arguments: [String], defaultValue: T) throws -> T
    func parseString(argument: StringShellArgument, from arguments: [String]) throws -> String
    func parseOptionalString(argument: StringShellArgument, from arguments: [String]) throws -> String?
    func parseInt(argument: IntShellArgument, from arguments: [String]) throws -> Int
}

final class ShellArgumentsParserImpl: ShellArgumentsParser {
    func parseEnum<T>(argument: EnumShellArgument<T>, from arguments: [String]) throws -> T {
        let value = try parseArgumentValue(
            name: argument.name,
            arguments: arguments,
            help: argument.help.value
        )

        return try argument.values[value] ?!+ "Shell parse error: Atribut --\(argument.name) have unexpected value: \"\(value)\". Available values: \"\(argument.help.value)\""
    }

    func parseOptionalEnum<T>(argument: EnumShellArgument<T>, from arguments: [String], defaultValue: T) throws -> T {
        let value = try parseOptionalArgumentValue(
            name: argument.name,
            arguments: arguments,
            help: argument.help.value
        )

        guard let key = value else {
            return defaultValue
        }

        return try argument.values[key] ?!+ "Shell parse error: Atribut --\(argument.name) have unexpected value: \"\(key)\". Available values: \"\(argument.help.value)\""
    }

    func parseString(argument: StringShellArgument, from arguments: [String]) throws -> String {
        return try parseArgumentValue(
            name: argument.name,
            arguments: arguments,
            help: argument.help.value
        )
    }

    func parseOptionalString(argument: StringShellArgument, from arguments: [String]) throws -> String? {
        return try parseOptionalArgumentValue(
            name: argument.name,
            arguments: arguments,
            help: argument.help.value
        )
    }

    func parseInt(argument: IntShellArgument, from arguments: [String]) throws -> Int {
        let value = try parseArgumentValue(
            name: argument.name,
            arguments: arguments,
            help: argument.help.value
        )

        return try Int(value) ?!+ "Shell parse error: can not convert value: \"\(value)\" to Int"
    }

    private func parseArgumentValue(name: String, arguments: [String], help: String) throws -> String {
        let valueIndex = try parseValueIndex(name: name, arguments: arguments, help: help)
        return try parseValue(at: valueIndex, name: name, arguments: arguments)
    }

    private func parseOptionalArgumentValue(name: String, arguments: [String], help: String) throws -> String? {
        guard let valueIndex = try? parseValueIndex(name: name, arguments: arguments, help: help) else {
            return nil
        }
        return try parseValue(at: valueIndex, name: name, arguments: arguments)
    }

    private func parseValueIndex(name: String, arguments: [String], help: String) throws -> Array<String>.Index {
        let keyIndex = try arguments.firstIndex(of: "--\(name)") ?!+ "Shell parse error: Missing attribute --\(name) \(help)"
        return arguments.index(after: keyIndex)
    }

    private func parseValue(at index: Array<String>.Index, name: String, arguments: [String]) throws -> String {
        guard arguments.indices.contains(index) else {
            throw ToolsError(description: "Shell parse error: Missing value of atribut --\(name)")
        }
        return arguments[index]
    }
}

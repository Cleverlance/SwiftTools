//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 02.08.2021.
//

public protocol HelpGenerator {
    func makeHelp(for cliInteractor: CLIInteractor) -> String
    func makeHelp(for argument: ShellArgumentHelp) -> String
}

final class HelpGeneratorImpl: HelpGenerator {
    func makeHelp(for cliInteractor: CLIInteractor) -> String {
        let title = "\(cliInteractor.getKeyword()): \(cliInteractor.getDescription())"
        let arguments = cliInteractor.getArguments().map(\.help).map(makeHelp(for:))
        return ([title] + arguments).joined(separator: "\n")
    }

    func makeHelp(for argument: ShellArgumentHelp) -> String {
        if argument.isOptional {
            return "  [--\(argument.name) \(argument.value)]  -  \(argument.description)"
        } else {
            return "  --\(argument.name) \(argument.value)  -  \(argument.description)"
        }
    }
}

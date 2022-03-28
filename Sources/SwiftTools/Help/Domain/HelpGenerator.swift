//
//  File.swift
//  File
//
//  Created by Kryštof Matěj on 02.08.2021.
//

public protocol HelpGenerator {
    func makeHelp(for cliInteractor: CLIInteractor) -> String
}

final class HelpGeneratorImpl: HelpGenerator {
    func makeHelp(for cliInteractor: CLIInteractor) -> String {
        let title = "\(cliInteractor.getKeyword()): \(cliInteractor.getDescription())"
        let arguments = cliInteractor.getArguments().map(\.help).map(makeArgumentHelp(for:))
        return ([title] + arguments).joined(separator: "\n")
    }

    private func makeArgumentHelp(for argument: ShellArgumentHelp) -> String {
        if argument.isOptional {
            return "  [--\(argument.name) \(argument.value)]  -  \(argument.description)"
        } else {
            return "  --\(argument.name) \(argument.value)  -  \(argument.description)"
        }
    }
}

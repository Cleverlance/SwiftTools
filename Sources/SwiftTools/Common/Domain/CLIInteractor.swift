//
//  File.swift
//
//
//  Created by Kryštof Matěj on 22.02.2021.
//

public protocol CLIInteractor {
    func execute(arguments: [String]) throws
    func getKeyword() -> String
    func getDescription() -> String
    func getArguments() -> [HelpableShellArgument]
}

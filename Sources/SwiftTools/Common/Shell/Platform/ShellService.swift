//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import SwiftCLI

public protocol ShellService {
    func execute(arguments: [String]) throws
    func executeWithResult(arguments: [String]) throws -> String
}

final class ShellServiceImpl: ShellService {
    private let printService: PrintService
    private let verboseController: VerboseController

    init(printService: PrintService, verboseController: VerboseController) {
        self.printService = printService
        self.verboseController = verboseController
    }

    func execute(arguments: [String]) throws {
        try executeTask(arguments: arguments)
    }

    func executeWithResult(arguments: [String]) throws -> String {
        return try executeTask(arguments: arguments)
    }

    @discardableResult private func executeTask(arguments: [String]) throws -> String {
        let output = CaptureStream()
        let error = CaptureStream()
        let outputStream = makeOutputStream(captureStream: output)

        let command = arguments.joined(separator: " ")
        let task = Task(executable: "/bin/bash", arguments: ["-c", command], stdout: outputStream, stderr: error)
        printService.printVerbose("shell command: '\(command)'") 
        let exitCode = task.runSync()

        let outputString = output.readAll()

        guard exitCode == 0 else {
            let errorMessage = error.readAll()
            printService.printText("Command output: \(outputString)")
            printService.printText("Command error: \(errorMessage)")
            let message = !errorMessage.isEmpty ? errorMessage : outputString
            throw ToolsError(description: "shell command: '\(command)' failed with error: '\(message)'")
        }
        return outputString
    }

    private func makeOutputStream(captureStream: CaptureStream) -> WritableStream {
        if verboseController.isVerbose() {
            return SplitStream(streams: [captureStream, WriteStream.stdout])
        } else {
            return captureStream
        }
    }
}

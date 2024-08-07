//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

import SwiftCLI
import XcbeautifyLib

public protocol ShellService {
    func execute(arguments: [String]) throws
    func executeWithVisibleOutput(arguments: [String]) throws
    func executeWithResult(arguments: [String]) throws -> String
    func executeWithXCBeautify(arguments: [String]) throws
}

final class ShellServiceImpl: ShellService {
    private let printService: PrintService
    private let verboseController: VerboseController

    init(printService: PrintService, verboseController: VerboseController) {
        self.printService = printService
        self.verboseController = verboseController
    }

    func execute(arguments: [String]) throws {
        try executeTask(arguments: arguments, isOutputVisible: verboseController.isVerbose())
    }

    func executeWithVisibleOutput(arguments: [String]) throws {
        try executeTask(arguments: arguments, isOutputVisible: true)
    }

    func executeWithResult(arguments: [String]) throws -> String {
        return try executeTask(arguments: arguments, isOutputVisible: verboseController.isVerbose())
    }

    @discardableResult private func executeTask(arguments: [String], isOutputVisible: Bool) throws -> String {
        let output = CaptureStream()
        let error = CaptureStream()
        let outputStream = makeOutputStream(captureStream: output, isOutputVisible: isOutputVisible)

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

    private func makeOutputStream(captureStream: CaptureStream, isOutputVisible: Bool) -> WritableStream {
        if isOutputVisible {
            return SplitStream(streams: [captureStream, WriteStream.stdout])
        } else {
            return captureStream
        }
    }

    func executeWithXCBeautify(arguments: [String]) throws {
        let printStream = WriteStream.stdout
        let parser = XCBeautifier(
            colored: true,
            renderer: .terminal,
            preserveUnbeautifiedLines: true,
            additionalLines: { nil }
        )
        let outputStream = makeBeautifyStream(outputStream: printStream, parser: parser)

        let command = arguments.joined(separator: " ")
        let task = Task(executable: "/bin/bash", arguments: ["-c", command], stdout: outputStream)
        let exitCode = task.runSync()

        guard exitCode == 0 else {
            throw ToolsError(description: "shell command: '\(command)' failed with error")
        }
    }

    private func makeBeautifyStream(outputStream: WritableStream, parser: XCBeautifier) -> ProcessingStream {
        return LineStream { line in
            if let formatted = parser.format(line: line) {
                outputStream.write(formatted + "\n")
            } else {
                outputStream.write(line + "\n")
            }
        }
    }
}

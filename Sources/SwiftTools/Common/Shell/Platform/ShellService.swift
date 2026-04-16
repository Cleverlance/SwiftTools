import Foundation

public protocol ShellService {
    func execute(arguments: [String]) throws
    func executeWithResult(arguments: [String]) throws -> String
    func executeWithProcessing(arguments: [String], onProcessLine: @escaping (String) -> Void) throws
}

nonisolated(unsafe) private var processes: [Process] = []

private func handleSignal(_ sig: Int32) {
    for p in processes where p.isRunning {
        kill(-p.processIdentifier, sig)
    }

    exit(sig)
}

final class ShellServiceImpl: ShellService, @unchecked Sendable {
    private let printService: PrintService

    init(printService: PrintService) {
        self.printService = printService
        self.setupSignalHandlers()
    }

    private func setupSignalHandlers() {
        signal(SIGINT) { _ in
            print("Killing self SIGINT, processes:\(processes.map(\.processIdentifier).map({ "\($0)"}).joined(separator: ", "))")
            handleSignal(SIGINT)
        }

        signal(SIGTERM) { _ in
            print("Killing self SIGTERM, processes:\(processes.map(\.processIdentifier).map({ "\($0)"}).joined(separator: ", "))")
            handleSignal(SIGTERM)
        }
    }

    func execute(arguments: [String]) throws {
        try executeWithProcessing(arguments: arguments, onProcessLine: { line in
            self.printService.printVerbose(line)
        })
    }

    func executeWithResult(arguments: [String]) throws -> String {
        var output = ""
        try executeWithProcessing(arguments: arguments, onProcessLine: { line in
            self.printService.printVerbose(line)
            output += line + "\n"
        })
        return output
    }

    func executeWithProcessing(arguments: [String], onProcessLine: @escaping (String) -> Void) throws {
        let command = arguments.joined(separator: " ")
        let process = Process()
        let pipe = Pipe()

        printService.printVerbose("shell command: '\(command)'")
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        process.standardOutput = pipe
        process.standardError = pipe

        let handle = pipe.fileHandleForReading
        var buffer = Data()


        try process.run()
        addProcessToChildManagement(process: process)

        while true {
            let data = handle.availableData
            if data.isEmpty { break }
            buffer.append(data)

            while let range = buffer.firstRange(of: Data([0x0A])) {
                let lineData = buffer.subdata(in: 0..<range.lowerBound)
                buffer.removeSubrange(0...range.lowerBound)

                if let line = String(data: lineData, encoding: .utf8) {
                    onProcessLine(line)
                }
            }
        }

        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw ToolsError(description: "shell command: '\(command)' failed with error")
        }
    }

    private func addProcessToChildManagement(process: Process) {
        processes.append(process)
        printService.printVerbose("Added processes:\(processes.map(\.processIdentifier).map({ "\($0)"}).joined(separator: ", "))")
        process.terminationHandler = { process in
            processes.removeAll { $0 === process }
            self.printService.printVerbose("Removed processes:\(processes.map(\.processIdentifier).map({ "\($0)"}).joined(separator: ", "))")
        }
    }
}

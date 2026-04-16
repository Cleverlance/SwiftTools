public protocol GetSimulatorIdUseCase {
    func callAsFunction(for platform: Platform, scheme: String) throws -> String
}

final class GetSimulatorIdUseCaseImp: GetSimulatorIdUseCase {
    private let shellService: ShellService
    private let printService: PrintService

    init(shellService: ShellService, printService: PrintService) {
        self.shellService = shellService
        self.printService = printService
    }

    func callAsFunction(for platform: Platform, scheme: String) throws -> String {
        let keys = makeSearchedKeys(for: platform)
        return try getDeviceId(for: keys, scheme: scheme)
    }

    private func getDeviceId(for keys: [String], scheme: String) throws -> String {
        let destinations = try shellService.executeWithResult(arguments: ["xcodebuild", "-scheme", scheme, "-showdestinations", "-quiet"])
        let components = destinations
            .components(separatedBy: "\n")
        let destination = try components.first(where: { isRowValid(keys: keys, row: $0) }) ?!+ "missing simulator"
        let attributes = destination.split(separator: " ")
        let idKeyValue = try attributes.first(where: { $0.starts(with: "id:") }) ?!+ "missing id in simulator row"
        var id = idKeyValue.dropFirst(3)

        if idKeyValue.last == "," {
            id = id.dropLast(1)
        }

        printService.printVerbose("Selecting device with id: \(id), for keys: \(keys)")
        return String(id)
    }

    private func isRowValid(keys: [String], row: String) -> Bool {
        return keys.reduce(true, { $0 && row.contains($1) })
    }

    private func makeSearchedKeys(for platform: Platform) -> [String] {
        switch platform {
        case .iOS:
            return ["platform:iOS Simulator", " OS:"]
        case .macOS:
            return ["variant:Mac Catalyst"]
        }
    }
}

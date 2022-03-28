//
//  File.swift
//
//
//  Created by Kryštof Matěj on 05.01.2021.
//

public protocol PrintService {
    func printText(_ text: String)
    func printVerbose(_ text: String)
}

final class PrintServiceImpl: PrintService {
    private let verboseController: VerboseController

    init(verboseController: VerboseController) {
        self.verboseController = verboseController
    }

    func printText(_ text: String) {
        print(text)
    }

    func printVerbose(_ text: String) {
        if verboseController.isVerbose() {
            printText(text)
        }
    }
}

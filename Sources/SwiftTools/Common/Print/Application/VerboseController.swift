//
//  File.swift
//
//
//  Created by Jan Halousek on 05.02.2021.
//

import Foundation

public protocol VerboseController {
    func setVerbose()
    func isVerbose() -> Bool
}

final class VerboseControllerImpl: VerboseController {
    private var isVerboseSetting = false

    func setVerbose() {
        isVerboseSetting = true
    }

    func isVerbose() -> Bool {
        return isVerboseSetting
    }
}

//
//  MockOpenSystemCommand.swift
//  masTests
//
//  Created by Ben Chatelain on 1/4/19.
//  Copyright © 2019 mas-cli. All rights reserved.
//

import Foundation

@testable import mas

class MockOpenSystemCommand: ExternalCommand {
    // Stub out protocol logic
    var succeeded = true
    var arguments: [String] = []

    // unused
    var binaryPath = "/dev/null"
    var process = Process()
    var stdoutPipe = Pipe()
    var stderrPipe = Pipe()

    func run(arguments: String...) throws {
        self.arguments = arguments
    }
}

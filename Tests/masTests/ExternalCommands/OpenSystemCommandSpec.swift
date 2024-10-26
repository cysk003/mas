//
//  OpenSystemCommandSpec.swift
//  masTests
//
//  Created by Ben Chatelain on 2/24/20.
//  Copyright © 2020 mas-cli. All rights reserved.
//

import Nimble
import Quick

@testable import mas

public class OpenSystemCommandSpec: QuickSpec {
    override public func spec() {
        beforeSuite {
            MAS.initialize()
        }
        describe("open system command") {
            context("binary path") {
                it("defaults to the macOS open command") {
                    expect(OpenSystemCommand().binaryPath) == "/usr/bin/open"
                }
                it("can be overridden") {
                    expect(OpenSystemCommand(binaryPath: "/dev/null").binaryPath) == "/dev/null"
                }
            }
        }
    }
}

//
//  SoftwareProductSpec.swift
//  masTests
//
//  Created by Ben Chatelain on 9/30/21.
//  Copyright © 2018 mas-cli. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import mas

public final class SoftwareProductSpec: QuickSpec {
    override public func spec() {
        let app = MockSoftwareProduct(
            appName: "App",
            bundleIdentifier: "",
            bundlePath: "",
            bundleVersion: "1.0.0",
            itemIdentifier: 111
        )

        beforeSuite {
            MAS.initialize()
        }
        describe("software product") {
            it("is not outdated when there is no new version available") {
                expect(app.isOutdated(comparedTo: SearchResult(version: "1.0.0"))) == false
            }
            it("is outdated when there is a new version available") {
                expect(app.isOutdated(comparedTo: SearchResult(version: "2.0.0"))) == true
            }
            it("is not outdated when the new version of mac-software requires a higher OS version") {
                expect(app.isOutdated(comparedTo: SearchResult(minimumOsVersion: "99.0.0", version: "3.0.0"))) == false
            }
            it("is not outdated when the new version of software requires a higher OS version") {
                expect(app.isOutdated(comparedTo: SearchResult(minimumOsVersion: "99.0.0", version: "3.0.0"))) == false
            }
        }
    }
}

//
//  VoticeDemoUITestsLaunchTests.swift
//  VoticeDemoUITests
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import XCTest

final class VoticeDemoUITestsLaunchTests: XCTestCase {
    // MARK: - Override to run tests for each target application UI configuration

    // swiftlint:disable static_over_final_class
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    // swiftlint:enable static_over_final_class

    // MARK: - Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Test

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways

        add(attachment)
    }
}

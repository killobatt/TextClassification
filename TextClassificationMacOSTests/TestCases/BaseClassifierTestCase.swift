//
//  BaseClassifierTestCase.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest

class BaseClassifierTestCase: XCTestCase {

    var testDatasets: TestDatasets!
    var bundleSettings: TestBundleSettings!

    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        guard let settings = TestBundleSettings(bundle: bundle) else {
            XCTFail("Could not load bundle settings")
            return
        }
        bundleSettings = settings
        testDatasets = TestDatasets(bundleSettings: settings)
    }

    override func tearDown() {
        testDatasets = nil
        bundleSettings = nil
    }
}

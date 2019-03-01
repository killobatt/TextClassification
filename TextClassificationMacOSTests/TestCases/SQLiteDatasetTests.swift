//
//  SQLiteDatasetTests.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
@testable import TextClassification

class SQLiteDatasetTests: BaseClassifierTestCase {

    var testedDataset: Dataset!

    override func setUp() {
        super.setUp()
        testedDataset = testDatasets.testDataset
    }

    override func tearDown() {
        testedDataset = nil
        bundleSettings = nil
        super.tearDown()
    }

    func testLoadAllMessages() {
        // GIVEN

        // WHEN
        let items = testedDataset.items

        // THEN
        XCTAssertEqual(items.count, 8647)
    }
}

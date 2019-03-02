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
        XCTAssertEqual(items.count, 8621)
    }

    func testAllLabels() {
        // GIVEN

        // WHEN
        let labels = testedDataset.labels

        // THEN
        XCTAssertEqual(labels, Set(arrayLiteral: "uk", "en", "ru", "de", "uk_translit", "ru_translit"))
    }

    func testSplitDataset() {
        // GIVEN
        let fraction = 0.5

        // WHEN
        let (trainingSet, testingSet) = testedDataset.splitTestDataset(startPersentage: 1.0 - fraction, endPersentage: 1.0)

        // THEN
        for label in testedDataset.labels {
            let trainingItems = trainingSet.items(for: label)
            let testingItems = testingSet.items(for: label)
            XCTAssertEqual(Double(trainingItems.count), Double(testingItems.count), accuracy: 1)
        }
    }
}

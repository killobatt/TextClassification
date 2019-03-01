//
//  TestDatasets.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation
import TextClassification

struct TestDatasets {
    private let bundleSettings: TestBundleSettings

    init(bundleSettings: TestBundleSettings) {
        self.bundleSettings = bundleSettings
    }

    var testDataset: Dataset  {
        do {
            let databaseURL = bundleSettings.resourcesURL.appendingPathComponent("spamer.db")
            return try SQLiteDataset(databasePath: databaseURL.path)
        } catch let error {
            fatalError("Error creating dataset: \(error)")
        }
    }
}

//
//  Dataset.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

public struct DatasetItem: Codable {
    public var id: Int
    public var text: String
    public var label: String
    public var predictedLabel: String?
}

public protocol Dataset {
    var items: [DatasetItem] { get }
}

public extension Dataset {
    public subscript(startPersentage: Double, endPersentage: Double) -> [DatasetItem] {
        get {
            guard 0 <= startPersentage, startPersentage < 1.0, 0 < endPersentage, endPersentage <= 1.0,
                startPersentage < endPersentage else {
                    return []
            }

            let items = self.items
            let startIndex = Int((Double(items.count) * startPersentage).rounded(.down))
            let endIndex = Int((Double(items.count) * endPersentage).rounded(.up))
            return Array(items[startIndex..<endIndex])
        }
    }

    public func splitTestDataset(startPersentage: Double, endPersentage: Double) -> (trainDataset: Dataset, testDataset: Dataset) {
        let trainDatasetItemsLeft = self[0, startPersentage]
        let trainDatasetItemsRight = self[endPersentage, 1]
        let testDatasetItems = self[startPersentage, endPersentage]
        return (trainDataset: RAMDataset(items: trainDatasetItemsLeft + trainDatasetItemsRight),
                testDataset: RAMDataset(items: testDatasetItems))

    }
}

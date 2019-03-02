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
    var labels: Set<String> { get }
    func items(for label: String) -> [DatasetItem]
}

public extension Dataset {
    public subscript(startPersentage: Double, endPersentage: Double) -> [DatasetItem] {
        get {
            guard 0 <= startPersentage, startPersentage < 1.0, 0 < endPersentage, endPersentage <= 1.0,
                startPersentage < endPersentage else {
                    return []
            }

            var result: [DatasetItem] = []
            for label in labels {
                let items = self.items(for: label)
                let startIndex = Int((Double(items.count) * startPersentage).rounded(.down))
                let endIndex = Int((Double(items.count) * endPersentage).rounded(.up))
                result.append(contentsOf: items[startIndex..<endIndex])
            }
            return result
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

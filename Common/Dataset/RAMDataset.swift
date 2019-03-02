//
//  RAMDataset.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public struct RAMDataset: Dataset {

    // MARK: - Dataset

    public var items: [DatasetItem]

    public var labels: Set<String> {
        return Set(items.map { $0.label })
    }

    public func items(for label: String) -> [DatasetItem] {
        return items.filter { $0.label == label }
    }
}

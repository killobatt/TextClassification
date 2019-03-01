//
//  TestResults.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

struct TestResults {
    var labelsTotal: Int
    var labelsMatched: Int
    var labelsUnpredicted: Int

    init() {
        labelsTotal = 0
        labelsMatched = 0
        labelsUnpredicted = 0
    }

    mutating func addResult(matched: Bool, predicted: Bool) {
        labelsTotal += 1
        labelsMatched = matched ? labelsMatched + 1 : labelsMatched
        labelsUnpredicted = predicted ? labelsUnpredicted : labelsUnpredicted + 1
    }

    var accuracy: Double {
        return Double(labelsMatched) / Double(labelsTotal)
    }

    var errorsRate: Double {
        return 1 - accuracy
    }

    static func + (lhs: TestResults, rhs: TestResults) -> TestResults {
        var result = TestResults()
        result.labelsTotal = lhs.labelsTotal + rhs.labelsTotal
        result.labelsMatched = lhs.labelsMatched + rhs.labelsMatched
        result.labelsUnpredicted = lhs.labelsUnpredicted + rhs.labelsUnpredicted
        return result
    }
}

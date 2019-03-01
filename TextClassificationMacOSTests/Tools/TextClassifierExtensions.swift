//
//  TextClassifierExtensions.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import TextClassification

extension TextClassifier {
    func test(on dataset: Dataset) -> TestResults {
        var results = TestResults()
        for item in dataset.items {
            let predictedLabel = self.predictedLabel(for: item.text)
            results.addResult(matched: predictedLabel == item.label, predicted: predictedLabel != nil)
        }
        return results
    }
}

extension TrainableTextClassifier {
    static func crossValidate(on dataset: Dataset, with preprocessor: Preprocessor) -> TestResults {
        let testDatasetLengthPersentage = 0.2
        var startTestPersentage = 0.0
        var results = TestResults()
        while startTestPersentage + testDatasetLengthPersentage <= 1 {
            let (trainDataset, testDataset) = dataset.splitTestDataset(startPersentage: startTestPersentage,
                                                                       endPersentage: startTestPersentage + testDatasetLengthPersentage)
            let classifier = train(with: preprocessor, on: trainDataset)
            results = results + classifier.test(on: testDataset)
            startTestPersentage += testDatasetLengthPersentage
        }
        return results
    }
}

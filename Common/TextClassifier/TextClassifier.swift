//
//  TextClassifier.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public protocol TextClassifier {
    func predictedLabel(for text: String) -> String?
}

public protocol TrainableTextClassifier: TextClassifier {
    static func train(with preprocessor: Preprocessor, on dataset: Dataset) -> TextClassifier
}

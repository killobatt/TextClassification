//
//  LanguageRecognizerClassifier.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import NaturalLanguage

public class LanguageRecognizerClassifier: TextClassifier {
    private let languageRecognizer: NLLanguageRecognizer

    public init() {
        languageRecognizer = NLLanguageRecognizer()
    }

    // MARK: - TextClassifier

    public static func train(on dataset: Dataset) -> TextClassifier {
        return LanguageRecognizerClassifier()
    }

    public func predictedLabel(for string: String) -> String? {
        languageRecognizer.processString(string)
        let label = languageRecognizer.dominantLanguage?.rawValue
        languageRecognizer.reset()
        return label
    }
}

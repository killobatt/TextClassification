//
//  ClassificationComparisonModel.swift
//  MessageFilteringApp
//
//  Created by Viacheslav Volodko on 3/1/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import TextClassification
import CoreML

struct ClassificationResult {
    var classifierName: String
    var resultLabel: String
}

class ClassificationComparisonModel {
    private(set) var classifiers: [NamedTextClassifier]

    init() {
        let languageRecognizerClassifier = LanguageRecognizerClassifier()
        let coreMLClassifier = CoreMLLanguageClassifier()
        let naiveBayesClassifier = NaiveBayesClassifier.loadClassifier()
        self.classifiers = [
            languageRecognizerClassifier,
            coreMLClassifier,
            naiveBayesClassifier,
        ]
    }

    func comparePrediction(for text: String) -> [ClassificationResult] {
        return classifiers.map { ClassificationResult(classifierName: $0.name,
                                                      resultLabel: $0.predictedLabel(for: text) ?? "unknown") }
    }
}

protocol NamedTextClassifier: TextClassifier {
    var name: String { get }
}

extension LanguageRecognizerClassifier: NamedTextClassifier {
    var name: String {
        return "NLLanguageRecognizer"
    }
}

extension CoreMLLanguageClassifier: NamedTextClassifier {
    var name: String {
        return "Core ML"
    }

    func predictedLabel(for text: String) -> String? {
        let prediction = try? self.prediction(text: text)
        return prediction?.label
    }
}

extension NaiveBayesClassifier: NamedTextClassifier {
    var name: String {
        return "Naive Bayes"
    }

    static func loadClassifier() -> NaiveBayesClassifier {
        guard let url = Bundle.main.url(forResource: "NaiveBayes", withExtension: "model") else {
            fatalError("Missing resource file: NaiveBayes.model")
        }
        do {
            return try NaiveBayesClassifier(fileURL: url, preprocessor: TrivialPreprocessor())
        } catch let error {
            fatalError("Error loading NaiveBayesClassifier from \(url):\n \(error)")
        }

    }
}

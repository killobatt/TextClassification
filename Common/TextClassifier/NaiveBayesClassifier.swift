//
//  NaiveBayesClassifier.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public class NaiveBayesClassifier: TrainableTextClassifier {

    // MARK: - NaiveBayesClassifier

    /// Trained model.
    /// Key is class, aka label
    /// Value is feature statistics dictionary: Key is feature (aka word), value is how often it was ever observed for given label
    typealias Model = [String: [String: Int]]
    private var model: Model = [:]
    private let preprocessor: Preprocessor
    private var laplasFactor: Double

    init(preprocessor: Preprocessor, model: Model, laplasFactor: Double = 0.3) {
        self.preprocessor = preprocessor
        self.model = model
        self.laplasFactor = laplasFactor
    }

    // MARK: - TrainableTextClassifier

    public static func train(with preprocessor: Preprocessor, on dataset: Dataset) -> TextClassifier {
        var model: Model = [:]
        dataset.items.forEach { item in
            let features = preprocessor.preprocess(text: item.text)
            if var statistics = model[item.label] {
                statistics.merge(features, uniquingKeysWith: +)
                model[item.label] = statistics
            } else {
                model[item.label] = features
            }
        }
        return NaiveBayesClassifier(preprocessor: preprocessor, model: model)
    }

    // MARK: - TextClassifier

    public func predictedLabel(for text: String) -> String? {
        let features = preprocessor.preprocess(text: text)
        return mostProbableLabel(of: features)?.label
    }

    // MARK: - Calculations

    func allLabels() -> [String] {
        return model.map { $0.key }
    }

    private var numberOfFeaturesByLabelCache: [String: Int] = [:]

    func cachingNumberOfFeatures(for label: String) -> Int {
        if let number = numberOfFeaturesByLabelCache[label] {
            return number
        } else {
            let number = numberOfFeatures(for: label)
            numberOfFeaturesByLabelCache[label] = number
            return number
        }
    }

    private var cachedTotalNumberOfFeatures: Int? = nil
    func cachingTotalNumberOfFeatures() -> Int {
        if let number = cachedTotalNumberOfFeatures {
            return number
        } else {
            let number = totalNumberOfFeatures()
            cachedTotalNumberOfFeatures = number
            return number
        }
    }

    func numberOfFeatures(for label: String) -> Int {
        guard let statistics = model[label] else { return 0 }
        return statistics.map { $0.value }.reduce(0, +)
    }

    func totalNumberOfFeatures() -> Int {
        return model.map { cachingNumberOfFeatures(for: $0.key) }.reduce(0, +)
    }

    func featureCountInIndex(feature: String, label: String) -> Int {
        return model[label]?[feature] ?? 0
    }

    func probability(of features: [String: Int], toHaveLabel label: String) -> Double {
        let totalNumberOfFeatures = Double(self.cachingTotalNumberOfFeatures())
        let numberOfLabelFeatures = Double(self.cachingNumberOfFeatures(for: label))
        var sum = log(numberOfLabelFeatures / totalNumberOfFeatures)
        for (feature, featureCount) in features {
            let featureCountInModel = Double(featureCountInIndex(feature: feature, label: label))
            sum += log(Double(featureCount) * (featureCountInModel + laplasFactor) /
                      (numberOfLabelFeatures + totalNumberOfFeatures * laplasFactor))
        }
        return sum
    }

    func mostProbableLabel(of features: [String: Int]) -> (label: String, probability: Double)? {
        let labelsByProbability = allLabels().reduce(into: [String: Double]()) { (result, label) in
            result[label] = probability(of: features, toHaveLabel: label)
        }

        let labelWithMaxProbability = labelsByProbability.max { (keyValue1, keyValue2) -> Bool in
            return keyValue1.value < keyValue2.value
        }

        guard let label = labelWithMaxProbability else { return nil }


        return (label: label.key, probability: label.value)
    }
}


extension NaiveBayesClassifier {
    public convenience init(fileURL: URL, preprocessor: Preprocessor) throws {
        let data = try Data(contentsOf: fileURL)
        let representation = try PropertyListDecoder().decode(StoredRepresentation.self, from: data)
        self.init(preprocessor: preprocessor,
                  model: representation.model,
                  laplasFactor: representation.laplasFactor)
    }

    public func store(toFile fileURL: URL) throws {
        let data = try PropertyListEncoder().encode(StoredRepresentation(model: model, laplasFactor: laplasFactor))
        try data.write(to: fileURL)
    }

    private struct StoredRepresentation: Codable {
        var model: Model
        var laplasFactor: Double
    }
}

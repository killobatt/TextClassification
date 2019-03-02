//
//  MemoryMappedNaiveBayesClassifier.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation
import MemoryMappedCollections

public class MemoryMappedNaiveBayesClassifier: TrainableTextClassifier {

    // MARK: - MemoryMappedNaiveBayesClassifier

    /// Trained model.
    /// Key is class, aka label
    /// Value is feature statistics dictionary: Key is feature (aka word), value is how often it was ever observed for given label
    typealias Model = [String: MMStringIntDictionary]
    private var model: Model = [:]
    private var modelBuilders: [String: MMStringIntDictionaryBuilder] = [:]
    private let preprocessor: Preprocessor
    private var laplasFactor: Double

    init(preprocessor: Preprocessor, model: Model, modelBuilders: [String: MMStringIntDictionaryBuilder] = [:], laplasFactor: Double = 0.3) {
        self.preprocessor = preprocessor
        self.model = model
        self.modelBuilders = modelBuilders
        self.laplasFactor = laplasFactor
    }

    // MARK: - TrainableTextClassifier

    public static func train(with preprocessor: Preprocessor, on dataset: Dataset) -> TextClassifier {
        var ramModel: [String: [String: Int]] = [:]
        dataset.items.forEach { item in
            let features = preprocessor.preprocess(text: item.text)
            if var statistics = ramModel[item.label] {
                statistics.merge(features, uniquingKeysWith: +)
                ramModel[item.label] = statistics
            } else {
                ramModel[item.label] = features
            }
        }

        var diskModel: Model = [:]
        var modelBuilders: [String: MMStringIntDictionaryBuilder] = [:]
        for (label, index) in ramModel {
            let builder = MMStringIntDictionaryBuilder(dictionary: index.mapValues { NSNumber(value: $0) })
            modelBuilders[label] = builder
            diskModel[label] = MMStringIntDictionary(data: builder.serialize())
        }
        return MemoryMappedNaiveBayesClassifier(preprocessor: preprocessor, model: diskModel, modelBuilders: modelBuilders)
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
        return Int(statistics.map { $0.value }.reduce(0, +))
    }

    func totalNumberOfFeatures() -> Int {
        return model.map { cachingNumberOfFeatures(for: $0.key) }.reduce(0, +)
    }

    func featureCountInIndex(feature: String, label: String) -> Int64 {
        let number = model[label]?.int64(forKey: feature) ?? 0
        if number == NSNotFound {
            return 0
        } else {
            return number
        }
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


extension MemoryMappedNaiveBayesClassifier {
    public convenience init(fileURL: URL, preprocessor: Preprocessor) throws {
        let data = try Data(contentsOf: fileURL.appendingPathComponent("info.plist"))
        let representation = try PropertyListDecoder().decode(StoredRepresentation.self, from: data)

        var model: Model = [:]
        for (label, filename) in representation.labelIndexFilenames {
            model[label] = try MMStringIntDictionary(fileURL: fileURL.appendingPathComponent(filename))
        }

        self.init(preprocessor: preprocessor,
                  model: model,
                  laplasFactor: representation.laplasFactor)
    }

    public func store(toDirectory directoryURL: URL) throws {
        guard !modelBuilders.isEmpty else {
            throw NSError(domain: "com.text.classifier", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Only model created by training can be stored on disk"
            ])
        }

        let fileManager = FileManager.default
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)

        let labelIndexFilenames = self.modelBuilders.keys.reduce(into: [String: String]()) { result, label in
            result[label] = label
        }

        let data = try PropertyListEncoder().encode(StoredRepresentation(laplasFactor: laplasFactor,
                                                                         labelIndexFilenames: labelIndexFilenames))
        try data.write(to: directoryURL.appendingPathComponent("info.plist"))

        for (label, filename) in labelIndexFilenames {
            let data = self.modelBuilders[label]?.serialize()
            try data?.write(to: directoryURL.appendingPathComponent(filename))
        }
    }

    private struct StoredRepresentation: Codable {
        var laplasFactor: Double
        var labelIndexFilenames: [String: String]
    }
}


extension MMStringIntDictionary {
    func map<T>(_ transform: ((key: String, value: Int64)) -> T) -> [T] {
        var array: [T] = []
        for key in self.allKeys {
            let value = self.int64(forKey: key)
            array.append(transform((key: key, value: value)))
        }
        return array
    }
}

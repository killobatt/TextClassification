//
//  CoreMLClassifier.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 2/26/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import CoreML

public class CoreMLClassifier: TextClassifier {

    public enum DataTableColumnName: String {
        case id
        case text
        case label
        case predictedLabel
    }

    private let mlModel: MLModel

    public init(mlModel: MLModel) {
        self.mlModel = mlModel
    }

    // MARK: - TextClassifier

    public func predictedLabel(for string: String) -> String? {
        guard let input = try? MLDictionaryFeatureProvider(dictionary: [DataTableColumnName.text.rawValue: string]) else {
            return nil
        }
        let prediction = try? mlModel.prediction(from: input)
        return prediction?.featureValue(for: DataTableColumnName.label.rawValue)?.stringValue
    }

}

extension CoreMLClassifier {
    public convenience init(fileURL: URL) throws {
        let model = try MLModel(contentsOf: fileURL)
        self.init(mlModel: model)
    }
}

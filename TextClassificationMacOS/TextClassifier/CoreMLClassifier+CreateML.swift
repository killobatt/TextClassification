//
//  CoreMLClassifier+CreateML.swift
//  TextClassificationMacOS
//
//  Created by Viacheslav Volodko on 2/26/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import CreateML

extension CoreMLClassifier: TrainableTextClassifier {
    public static func train(with preprocessor: Preprocessor, on dataset: Dataset) -> TextClassifier {
        let mlClassifier = trainMLClassifier(with: preprocessor, on: dataset)
        return CoreMLClassifier(mlModel: mlClassifier.model)
    }

    public static func trainMLClassifier(with preprocessor: Preprocessor, on dataset: Dataset) -> MLTextClassifier {
        do {
            let trainingDataTable = dataset.mlDataTable(preprocessedUsing: preprocessor)
            let mlClassifier = try MLTextClassifier(trainingData: trainingDataTable,
                                                    textColumn: DataTableColumnName.text.rawValue,
                                                    labelColumn: DataTableColumnName.label.rawValue)
            return mlClassifier
        } catch let error {
            fatalError("Error training classifier: \(error)")
        }
    }
}

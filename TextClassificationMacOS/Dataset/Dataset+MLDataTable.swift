//
//  Dataset+MLDataTable.swift
//  TextClassificationMacOS
//
//  Created by Viacheslav Volodko on 2/26/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import CreateML

extension Dataset {

    typealias Column = CoreMLClassifier.DataTableColumnName

    func mlDataTable(preprocessedUsing preprocessor: Preprocessor? = nil) -> MLDataTable {
        let data: [String: MLDataValueConvertible] = [
            Column.id.rawValue: items.map { $0.id },
            Column.text.rawValue: items.map { preprocessor?.preprocessedText(for: $0.text) ?? $0.text },
            Column.label.rawValue: items.map { $0.label },
        ]

        do {
            return try MLDataTable(dictionary: data)
        } catch let error {
            fatalError("Error creating data table: \(error)")
        }
    }
}

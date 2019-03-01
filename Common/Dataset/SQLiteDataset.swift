//
//  SQLiteDataset.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import SQLite

public class SQLiteDataset: Dataset {

    // MARK: - SQLiteDataset

    private let database: SQLite.Connection

    public init(databasePath: String) throws {
        self.database = try SQLite.Connection(databasePath)
    }

    private struct SQLRequests {
        static let allMessages = """
                                 SELECT id, text, language_code
                                 FROM message
                                 WHERE language_code is NOT NULL;
                                 """
    }

    // MARK: - Dataset

    public var items: [DatasetItem] {
        do {
            return try database.prepare(SQLRequests.allMessages).compactMap { DatasetItem(row: $0) }
        } catch let error {
            assertionFailure("Failed to execute SQL request: \(SQLRequests.allMessages), error: \(error)")
            return []
        }
    }
}

fileprivate extension DatasetItem {
    init?(row: SQLite.Statement.Element) {
        guard row.count >= 3,
            let id = row[0] as? Int64,
            let text = row[1] as? String,
            let languageCode = row[2] as? String else {
                return nil
        }

        self.id = Int(id)
        self.text = text
        self.label = languageCode
        self.predictedLabel = nil
    }
}

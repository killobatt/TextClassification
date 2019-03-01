//
//  Preprocessor.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public protocol Preprocessor {
    /// Preprocesses text of DatasetItem.
    /// - returns: a feature dictionary: Key is feature (e.g. word), Value is how many times it is observed in text.
    func preprocess(text: String) -> [String: Int]

    func preprocessedText(for text: String) -> String
}

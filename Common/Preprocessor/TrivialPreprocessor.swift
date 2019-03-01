//
//  TrivialPreprocessor.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public class TrivialPreprocessor: Preprocessor {

    public init() { }

    public func words(of text: String) -> [String] {
        let words = text
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.components(separatedBy: CharacterSet.punctuationCharacters).joined() }
            .filter { !$0.isEmpty }
        return words
    }

    public func preprocess(text: String) -> [String: Int] {
        let features = words(of: text).reduce(into: [String: Int]()) { result, word in
            result[word, default: 0] += 1
        }
        return features
    }

    public func preprocessedText(for text: String) -> String {
        return words(of: text).joined(separator: " ")
    }

}

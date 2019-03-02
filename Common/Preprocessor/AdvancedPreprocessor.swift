//
//  AdvancedPreprocessor.swift
//  MemoryMappedCollectionsTests
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

public class AdvancedPreprocessor: Preprocessor {

    public func words(of text: String) -> [String] {
        var preprocessedText = text

        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .link, .date]
        if let detector = try? NSDataDetector(types: types.rawValue) {
            preprocessedText = detector.stringByReplacingMatches(in: text,
                                                                 options: [],
                                                                 range: NSRange(location: 0, length: preprocessedText.count),
                                                                 withTemplate: " ")
        }

        if let numberSequenceRegexp = try? NSRegularExpression(pattern: "\\d+") {
            preprocessedText = numberSequenceRegexp.stringByReplacingMatches(in: preprocessedText,
                                                                             options: [],
                                                                             range: NSRange(location: 0, length: preprocessedText.count),
                                                                             withTemplate: "")
        }

        let words = preprocessedText
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.components(separatedBy: CharacterSet.punctuationCharacters).joined() }
            .filter { !$0.isEmpty }
        return words
    }

    public func preprocess(text: String) -> [String : Int] {
        let features = words(of: text).reduce(into: [String: Int]()) { result, word in
            result[word, default: 0] += 1
        }
        return features
    }

    public func preprocessedText(for text: String) -> String {
        return words(of: text).joined(separator: " ")
    }
}

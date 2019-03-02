//
//  MessageFilterExtension.swift
//  MessageFilteringExtension
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import IdentityLookup
import TextClassification

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        let action = self.action(for: queryRequest)
        completion(ILMessageFilterQueryResponse(action: action))
    }
    
    private func action(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        guard let messageText = queryRequest.messageBody,
            let classifier = loadMemoryMappedNaiveBayesClassifier(),
            let label = classifier.predictedLabel(for: messageText) else {
                return .none
        }

        return label.contains("translit") ? .filter : .allow
    }

    private func loadClassifier() -> TextClassifier? {
        guard let classifierURL = Bundle(for: type(of: self)).url(forResource: "CoreMLLanguageClassifier",
                                                                  withExtension: "mlmodelc"),
            let classifier = try? CoreMLClassifier(fileURL: classifierURL) else {
                return nil
        }
        return classifier
    }

    private func loadLanguageRecognizerClassifier() -> LanguageRecognizerClassifier? {
        return LanguageRecognizerClassifier()
    }

    private func loadCoreMLClassifier() -> CoreMLClassifier? {
        guard let classifierURL = Bundle(for: type(of: self)).url(forResource: "CoreMLLanguageClassifier",
                                                                  withExtension: "mlmodelc") else {
            return nil
        }
        return try? CoreMLClassifier(fileURL: classifierURL)
    }

    private func loadNaiveBayesClassifier() -> NaiveBayesClassifier? {
        guard let url = Bundle(for: type(of: self)).url(forResource: "NaiveBayes", withExtension: "model") else {
            return nil
        }
        return try? NaiveBayesClassifier(fileURL: url, preprocessor: TrivialPreprocessor())
    }

    private func loadMemoryMappedNaiveBayesClassifier() -> MemoryMappedNaiveBayesClassifier? {
        guard let url = Bundle(for: type(of: self)).url(forResource: "MemoryMappedBayes", withExtension: "model") else {
            return nil
        }
        return try? MemoryMappedNaiveBayesClassifier(fileURL: url, preprocessor: TrivialPreprocessor())
    }
}

extension ILMessageFilterQueryResponse {
    convenience init(action: ILMessageFilterAction) {
        self.init()
        self.action = action
    }
}

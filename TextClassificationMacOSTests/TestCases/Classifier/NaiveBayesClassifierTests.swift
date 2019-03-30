//
//  NaiveBayesClassifierTests.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
@testable import TextClassification

class NaiveBayesClassifierTests: BaseClassifierTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTrain() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset

        // WHEN
        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: testDataset) as! NaiveBayesClassifier
        try? classifier.store(toFile: bundleSettings.outputURL.appendingPathComponent("NaiveBayes.model"))

        // THEN
        let ukrPrediction = classifier.predictedLabel(for: "Вас вітає Славік!")
        XCTAssertEqual(ukrPrediction, "uk")

        let engPrediction = classifier.predictedLabel(for: "Welcome to paradise")
        XCTAssertEqual(engPrediction, "en")

        let dePrediction = classifier.predictedLabel(for: "Has du bist?")
        XCTAssertEqual(dePrediction, "de")

        let translitUkrPrediction = classifier.predictedLabel(for: "Vashe zamovlennya gotove. " +
            "Uvaga: rezultat v laboratornomu centri za predjavlennyam formy zamovlennya abo pasporta.")

        XCTAssertEqual(translitUkrPrediction, "uk_translit")

        let translitRusPrediction = classifier.predictedLabel(for: "Kruto! Vash zakaz oplachen. Na mail@example.com " +
            "otpravleny Vashy bilety. Ssylka na eti zhe bilety.")
        XCTAssertEqual(translitRusPrediction, "ru_translit")
    }

    func testAccuracy() {
        // GIVEN
        let (trainDataset, testDataset) = self.testDatasets.testDataset.splitTestDataset(startPersentage: 0.8,
                                                                                         endPersentage: 1.0)

        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: trainDataset)

        // WHEN
        let testResults = classifier.test(on: testDataset)

        // THEN
        XCTAssertGreaterThan(testResults.accuracy, 1.0)
    }

    func testCrossvalidate() {
        // GIVEN
        let dataset = self.testDatasets.testDataset

        // WHEN
        let results = NaiveBayesClassifier.crossValidate(on: dataset, with: TrivialPreprocessor())

        // THEN
        XCTAssertGreaterThan(results.accuracy, 1.0)
    }

    func testAllLabels() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset
        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: testDataset) as! NaiveBayesClassifier

        // WHEN
        let allLabels = classifier.allLabels()

        // THEN
        XCTAssertEqual(allLabels.sorted(), ["en", "uk", "ru", "de", "uk_translit", "ru_translit"].sorted())
    }

    func testNumberOfFeatures() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset
        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: testDataset) as! NaiveBayesClassifier

        // WHEN
        let numberOfFeatures = classifier.allLabels().reduce(into: [String: Int]()) { result, label in
            result[label] = classifier.numberOfFeatures(for: label)
        }

        // THEN
        XCTAssertEqual(numberOfFeatures, ["en": 52012,
                                          "uk": 52146,
                                          "ru": 34190,
                                          "de": 16868,
                                          "uk_translit": 5557,
                                          "ru_translit": 3025])
    }

    func testNumberOfFeatureInLabelIndex() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset
        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: testDataset) as! NaiveBayesClassifier

        // WHEN
        let numberOfFeatures = classifier.allLabels().reduce(into: [String: Int]()) { result, label in
            result[label] = classifier.featureCountInIndex(feature: "вітає", label: label)
        }

        // THEN
        XCTAssertEqual(numberOfFeatures, ["en": 0,
                                          "uk": 18,
                                          "ru": 0,
                                          "de": 0,
                                          "uk_translit": 0,
                                          "ru_translit": 0])
    }

    func testProbabilityOfFeatures() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset
        let preprocessor = TrivialPreprocessor()
        let classifier = NaiveBayesClassifier.train(with: preprocessor, on: testDataset) as! NaiveBayesClassifier
        let features = preprocessor.preprocess(text: "Вас вітає Славік!")

        // WHEN
        let probabilityOfFeatures = classifier.allLabels().reduce(into: [String: Double]()) { result, label in
            result[label] = classifier.probability(of: features, toHaveLabel: label)
        }

        // THEN
        XCTAssertEqual(probabilityOfFeatures["en"]!, -39.33, accuracy: 0.01)
        XCTAssertEqual(probabilityOfFeatures["uk"]!, -28.46, accuracy: 0.01)
        XCTAssertEqual(probabilityOfFeatures["ru"]!, -33.72, accuracy: 0.01)
        XCTAssertEqual(probabilityOfFeatures["de"]!, -39.17, accuracy: 0.01)
        XCTAssertEqual(probabilityOfFeatures["uk_translit"]!, -39.72, accuracy: 0.01)
        XCTAssertEqual(probabilityOfFeatures["ru_translit"]!, -40.19, accuracy: 0.01)
    }

    func testPerformance() {
        // GIVEN
        let testDataset = self.testDatasets.testDataset

        // WHEN
        let classifier = NaiveBayesClassifier.train(with: TrivialPreprocessor(), on: testDataset) as! NaiveBayesClassifier

        // THEN
        self.measure {
            _ = classifier.predictedLabel(for: "Вас вітає Славік!")

            _ = classifier.predictedLabel(for: "Welcome to paradise")

            _ = classifier.predictedLabel(for: "Has du bist?")

            _ = classifier.predictedLabel(for: "Vashe zamovlennya gotove. " +
                "Uvaga: rezultat v laboratornomu centri za predjavlennyam formy zamovlennya abo pasporta.")

            _ = classifier.predictedLabel(for: "Kruto! Vash zakaz oplachen. Na mail@example.com " +
                "otpravleny Vashy bilety. Ssylka na eti zhe bilety.")
        }
    }
}

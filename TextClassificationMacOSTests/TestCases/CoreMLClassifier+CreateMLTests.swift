//
//  CoreMLClassifier+CreateMLTests.swift
//  TextClassificationMacOSTests
//
//  Created by Viacheslav Volodko on 2/27/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
@testable import TextClassification

class CoreMLClassifier_CreateMLTests: BaseClassifierTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTrain() {
        // GIVEN
        let preprocessor = TrivialPreprocessor()
        let testDataset = self.testDatasets.testDataset
 
        // WHEN
        let mlClassifier = CoreMLClassifier.trainMLClassifier(with: preprocessor, on: testDataset)
        try? mlClassifier.write(to: bundleSettings.outputURL.appendingPathComponent("CoreMLLanguageClassifier.mlmodel"))
        let classifier = CoreMLClassifier(mlModel: mlClassifier.model)

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
        let preprocessor = TrivialPreprocessor()
        let (trainDataset, testDataset) = self.testDatasets.testDataset.splitTestDataset(startPersentage: 0.8,
                                                                                         endPersentage: 1.0)

        let classifier = CoreMLClassifier.train(with: preprocessor, on: trainDataset)

        // WHEN
        let testResults = classifier.test(on: testDataset)

        // THEN
        XCTAssertGreaterThan(testResults.accuracy, 1.0)
    }

    func testCrossvalidate() {
        // GIVEN
        let preprocessor = TrivialPreprocessor()
        let dataset = self.testDatasets.testDataset

        // WHEN
        let results = CoreMLClassifier.crossValidate(on: dataset, with: preprocessor)

        // THEN
        XCTAssertGreaterThan(results.accuracy, 1.0)
    }
}

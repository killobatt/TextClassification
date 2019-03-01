//
//  LanguageRecognizerClassifierTests.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/24/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
@testable import TextClassification

class LanguageRecognizerClassifierTests: BaseClassifierTestCase {

    var testedClassifier: LanguageRecognizerClassifier!

    override func setUp() {
        super.setUp()
        testedClassifier = LanguageRecognizerClassifier()
    }

    override func tearDown() {
        testedClassifier = nil
        super.tearDown()
    }

    func testTrain() {
        // GIVEN

        // WHEN

        // THEN
        let ukrPrediction = testedClassifier.predictedLabel(for: "Вас вітає Славік!")
        XCTAssertEqual(ukrPrediction, "uk")

        let engPrediction = testedClassifier.predictedLabel(for: "Welcome to paradise")
        XCTAssertEqual(engPrediction, "en")

        let dePrediction = testedClassifier.predictedLabel(for: "Has du bist?")
        XCTAssertEqual(dePrediction, "de")

        let translitUkrPrediction = testedClassifier.predictedLabel(for: "Vashe zamovlennya gotove. " +
            "Uvaga: rezultat v laboratornomu centri za predjavlennyam formy zamovlennya abo pasporta.")
        XCTAssertEqual(translitUkrPrediction, "uk_translit")

        let translitRusPrediction = testedClassifier.predictedLabel(for: "Kruto! Vash zakaz oplachen. Na mail@example.com " +
            "otpravleny Vashy bilety. Ssylka na eti zhe bilety.")
        XCTAssertEqual(translitRusPrediction, "ru_translit")
    }

    func testAccuracy() {
        // GIVEN
        let testDataset = testDatasets.testDataset

        // WHEN
        let results = testedClassifier.test(on: testDataset)

        // THEN
        XCTAssertGreaterThan(results.accuracy, 1.0)
    }
}

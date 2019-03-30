//
//  MMStringIntDictionaryTests.swift
//  MemoryMappedCollectionsTests
//
//  Created by Viacheslav Volodko on 3/2/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import XCTest
import MemoryMappedCollections

class MMStringIntDictionaryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBuildDictionary() {
        // GIVEN
        let testDictionary = [
            "hello": 1,
            "world": 2,
        ].mapValues { NSNumber(value: $0) }

        // WHEN
        let dictionaryBuilder = MMStringIntDictionaryBuilder(dictionary: testDictionary)
        let data = dictionaryBuilder.serialize()

        // THEN
        let dictionary = MMStringIntDictionary(data: data)
        XCTAssertEqual(dictionary.int64(forKey: "hello"), 1)
        XCTAssertEqual(dictionary.int64(forKey: "world"), 2)
        XCTAssertEqual(dictionary.int64(forKey: "not_found"), Int64(NSNotFound))
    }

    func testAllKeys() {
        // GIVEN
        let testDictionary = [
            "hello": 1,
            "world": 2,
            ].mapValues { NSNumber(value: $0) }

        // WHEN
        let dictionaryBuilder = MMStringIntDictionaryBuilder(dictionary: testDictionary)
        let data = dictionaryBuilder.serialize()

        // THEN
        let dictionary = MMStringIntDictionary(data: data)
        XCTAssertEqual(dictionary.allKeys.sorted(), ["hello", "world"].sorted())
    }

    func testBuildPerformance() {
        // GIVEN
        let testDictionary = Array(0..<100_000)
            .map { _ in UUID().uuidString }
            .reduce(into: [String: UInt32]()) { result, value in
                result[value] = arc4random()
            }
            .mapValues { NSNumber(value: $0) }

        self.measure {
            // MEASURE
            let builder = MMStringIntDictionaryBuilder(dictionary: testDictionary)
            _ = builder.serialize()
        }
    }

    func testReadAndGetPerformance() {
        // GIVEN
        let keys = Array(0..<100_000).map { _ in UUID().uuidString }
        let testDictionary = keys
            .reduce(into: [String: UInt32]()) { result, value in
                result[value] = arc4random()
            }
            .mapValues { NSNumber(value: $0) }

        let builder = MMStringIntDictionaryBuilder(dictionary: testDictionary)
        let data = builder.serialize()

        self.measure {
            // MEASURE
            let dictionary = MMStringIntDictionary(data: data)
            let _ = keys.map { dictionary.int64(forKey: $0) }
        }
    }

    func testReadPerformance() {
        // GIVEN
        let keys = Array(0..<100_000).map { _ in UUID().uuidString }
        let testDictionary = keys
            .reduce(into: [String: UInt32]()) { result, value in
                result[value] = arc4random()
            }
            .mapValues { NSNumber(value: $0) }

        let builder = MMStringIntDictionaryBuilder(dictionary: testDictionary)
        let data = builder.serialize()
        let dictionary = MMStringIntDictionary(data: data)

        self.measure {
            // MEASURE
            let _ = keys.map { dictionary.int64(forKey: $0) }
        }
    }

    func testDictionaryComparePerformance() {
        // GIVEN
        let keys = Array(0..<100_000).map { _ in UUID().uuidString }
        let testDictionary = keys
            .reduce(into: [String: UInt32]()) { result, value in
                result[value] = arc4random()
            }
            .mapValues { NSNumber(value: $0) }

        self.measure {
            // MEASURE
            let _ = keys.map { testDictionary[$0] }
        }
    }

}

//
//  TestBundleSettings.swift
//  TextClassificationTests
//
//  Created by Viacheslav Volodko on 2/26/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import Foundation

struct TestBundleSettings {
    var resourcesURL: URL
    var outputURL: URL

    init?(bundle: Bundle) {
        guard let settings = bundle.infoDictionary?[Keys.settings.rawValue] as? [String: String],
            let resourcesPath = settings[Keys.resourcesPath.rawValue],
            let outputPath = settings[Keys.outputPath.rawValue] else {
                return nil
        }

        self.resourcesURL = URL(fileURLWithPath: resourcesPath)
        self.outputURL = URL(fileURLWithPath: outputPath)
    }

    private enum Keys: String {
        case settings = "test-settings"
        case resourcesPath = "resources_path"
        case outputPath = "output_path"
    }
}

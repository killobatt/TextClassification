//
//  ClassifierComparisonResultCell.swift
//  MessageFilteringApp
//
//  Created by Viacheslav Volodko on 3/1/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import UIKit

class ClassifierComparisonResultCell: UITableViewCell {

    // MARK: - DI

    var result: ClassificationResult? {
        didSet {
            updateUI()
        }
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var classifierNameLabel: UILabel!
    @IBOutlet private weak var classificationResultLabel: UILabel!

    // MARK: - UITableViewCell

    static var reuseIdentifier: String {
        return "\(self)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    // MARK: - Private

    private func updateUI() {
        classifierNameLabel.text = result?.classifierName ?? "--"
        classificationResultLabel.text = result?.resultLabel ?? "--"
    }
}

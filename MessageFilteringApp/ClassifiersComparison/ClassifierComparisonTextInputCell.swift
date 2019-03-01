//
//  ClassifierComparisonTextInputCell.swift
//  MessageFilteringApp
//
//  Created by Viacheslav Volodko on 3/1/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import UIKit

protocol ClassifierComparisonTextInputCellDelegate {
    func textChanged(_ text: String)
}

class ClassifierComparisonTextInputCell: UITableViewCell {

    // MARK: - DI

    var delegate: ClassifierComparisonTextInputCellDelegate?

    // MARK: - IBOutlet

    @IBOutlet private weak var textView: UITextView!

    // MARK: - UITableViewCell

    static var reuseIdentifier: String {
        return "\(self)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
}

extension ClassifierComparisonTextInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textChanged(textView.text)
    }
}

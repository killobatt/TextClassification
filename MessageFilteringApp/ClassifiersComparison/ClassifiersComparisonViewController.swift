//
//  ClassifiersComparisonViewController.swift
//  TextClassification
//
//  Created by Viacheslav Volodko on 3/1/19.
//  Copyright © 2019 killobatt. All rights reserved.
//

import UIKit

class ClassifiersComparisonViewController: UITableViewController {

    // MARK: - Data

    var model: ClassificationComparisonModel!
    var results: [ClassificationResult] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        model = ClassificationComparisonModel()
    }

    // MARK: - UITableViewController

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return results.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: ClassifierComparisonTextInputCell.reuseIdentifier,
                                                 for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: ClassifierComparisonResultCell.reuseIdentifier,
                                                 for: indexPath)
        }

        if let textInputCell = cell as? ClassifierComparisonTextInputCell {
            textInputCell.delegate = self
        } else if let resultCell = cell as? ClassifierComparisonResultCell {
            resultCell.result = results[indexPath.row]
        }

        return cell
    }
}


extension ClassifiersComparisonViewController: ClassifierComparisonTextInputCellDelegate {
    func textChanged(_ text: String) {
        results = model.comparePrediction(for: text)
        tableView.reloadSections(IndexSet([1]), with: .none)
    }
}

//
//  ActivityDetailViewController.swift
//  Since
//
//  Created by Alok Karnik on 20/08/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    @IBOutlet var tableViewContainer: UIView!
    var activity: Activity!

    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var occurrenceTableView: UITableView!

    private var editMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        daysLabel.text = "\(activity.daysSinceLastOccurence)"
        activityLabel.text = activity.title

        setupTableView()
        setupNavigationController()
    }

    @objc private func setEditMode() {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setEditMode))

        if editMode {
            editMode = false
        } else {
            editButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(setEditMode))
            editMode = true
        }

        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        occurrenceTableView.reloadData()
    }
}

extension ActivityDetailViewController {
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.hexColour(hexValue: 0xEEB357, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black

        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setEditMode))

        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }

    private func setupTableView() {
        occurrenceTableView.delegate = self
        occurrenceTableView.dataSource = self

        tableViewContainer.layer.cornerRadius = 30
        tableViewContainer.clipsToBounds = true

        // Setup shadow
        tableViewContainer.layer.shadowOffset = .zero
        tableViewContainer.layer.shadowRadius = 10
        tableViewContainer.layer.shadowColor = UIColor.black.cgColor
        tableViewContainer.layer.shadowOpacity = 1

        occurrenceTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        occurrenceTableView.tableFooterView = UIView()
        occurrenceTableView.separatorStyle = .none
        occurrenceTableView.backgroundColor = UIColor.hexColour(hexValue: 0xE5E5E5, alpha: 1)
    }
}

extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        activity.pastOccurences.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = occurrenceTableView.dequeueReusableCell(withIdentifier: "previousDateTableViewCell") as! PreviousDateTableViewCell

        let isFirstCell: Bool = indexPath.row == 0 ? true : false
        cell.editMode = editMode

        let isOnlyCell = activity.pastOccurences.count == 1 ? true : false

        if indexPath.row < activity.pastOccurences.count - 1 {
            cell.setupWith(associatedDate: activity.pastOccurences[indexPath.row], andPreviousDate: activity.pastOccurences[indexPath.row + 1], isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        } else {
            cell.setupWith(associatedDate: activity.pastOccurences[indexPath.row], andPreviousDate: nil, isFirstCell: isFirstCell, isOnlyCell: isOnlyCell)
        }
        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return "   Past Occurrences"
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 40
    }
}

//
//  DeploymentLoadListViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct Item: Codable {
    var name: String?
    var quantity: String?
}

class DeploymentLoadListViewController: ViewController<DeploymentLoadListViewModel> {

//    @IBOutlet weak var deploymentIcon: UIImageView!
//    @IBOutlet weak var joinDeploymentButtonView: UIView!
    @IBOutlet weak var loadListTableView: UITableView!
//    @IBOutlet weak var organiserLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!

//    @IBOutlet weak var joinDeploymentLabel: UILabel!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let tableViewAdapter = TableViewAdapter<Item>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.ready()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.observeQuery()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObserving()
    }

    deinit {
        viewModel.stopObserving()
    }

    private func bindViewModel() {
        viewModel.didChangeData = { [weak self] data in
            guard let strongSelf = self else { return }
            /*if data.isUserAPassenger {
                strongSelf.disableButton()
            }*/

            let deployment = data.deployment
            // TODO: get the user from a user id
            //strongSelf.organiserLabel.text = "Organiser: \(deployment.ownerId)"
            //strongSelf.titleLabel.text = deployment.name
            strongSelf.tableViewAdapter.update(with: data.loadList)
            strongSelf.loadListTableView.reloadData()
        }

        loadListTableView.dataSource = tableViewAdapter
        loadListTableView.delegate = tableViewAdapter
        //activityIndicator.isHidden = true

        tableViewAdapter.cellFactory = { (tableView, indexPath, cellData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            //cell.textLabel?.text = cellData.userName
            cell.textLabel?.text = cellData.name
            cell.detailTextLabel?.text = cellData.quantity
            return cell
        }

        //let gesture = UITapGestureRecognizer(target: self, action: #selector(self.joinPressed))
        //addToDeploymentLoadListButtonView.addGestureRecognizer(gesture)
/*
        viewModel.addToDeploymentLoadListRequestCompleted = { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.isHidden = true
            strongSelf.joinDeploymentLabel.isHidden = false
        }*/
    }
/*
    private func disableButton() {
        joinDeploymentButtonView.backgroundColor = UIColor.gray
        joinDeploymentButtonView.isUserInteractionEnabled = false
    }

    @objc func joinPressed(sender: UITapGestureRecognizer) {
        viewModel.joinDeployment()
        activityIndicator.isHidden = false
        joinDeploymentLabel.isHidden = true
    }*/
}


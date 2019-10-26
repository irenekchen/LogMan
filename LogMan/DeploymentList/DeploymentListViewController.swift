//
//  DeploymentListViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SnapKit

class DeploymentListViewController: ViewController<DeploymentListViewModel> {

    @IBOutlet weak var tableView: UITableView!
    private var selectedDeployment: Deployment?
    private var selectedDeploymentReference: DocumentReference?

    @IBOutlet weak var createDeploymentButton: UIView!
    private let tableViewAdapter = TableViewAdapter<Deployment>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.didChangeData = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.tableViewAdapter.update(with: data.deployments)
            strongSelf.tableView.reloadData()
        }

        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter
        tableView.estimatedRowHeight = 200
        

        tableViewAdapter.cellFactory = { (tableView, indexPath, cellData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DeploymentTableViewCell else { return UITableViewCell() }
            cell.populate(deployment: cellData)
            return cell
        }

        tableViewAdapter.didSelectItem = { [weak self] rowData, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deselectRow(at: indexPath, animated: true)
            strongSelf.selectedDeployment = rowData
            strongSelf.selectedDeploymentReference = strongSelf.viewModel.documents[indexPath.row].reference
            strongSelf.detailPressed()
        }

        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addPressed))
        createDeploymentButton.addGestureRecognizer(gesture)
    }

    func detailPressed() {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    @objc func addPressed(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "addDeployment", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "showDetail" {
            let detailViewModel = DeploymentDetailViewModel(viewData: DeploymentDetailViewData(deployment: selectedDeployment!, deploymentReference: selectedDeploymentReference!, passengers: [], isUserAPassenger: false))
            let vc = segue.destination as? DeploymentDetailViewController
            vc?.viewModel = detailViewModel
            return
        }

        guard
            let viewController = segue.destination as? NewDeploymentViewController
            else { return }

        viewController.viewModel = NewDeploymentViewModel()
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
}

class DeploymentTableViewCell: UITableViewCell {

    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var deploymentIcon: UIImageView!
    @IBOutlet weak var deploymentNameLabel: UILabel!

    func populate(deployment: Deployment) {
        organiserLabel.text = deployment.ownerId
        deploymentNameLabel.text = deployment.name
        
        
    }
}


//
//  DeploymentDetailViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class DeploymentDetailViewController: ViewController<DeploymentDetailViewModel> {

    @IBOutlet weak var deploymentIcon: UIImageView!
    @IBOutlet weak var joinDeploymentButtonView: UIView!
    @IBOutlet weak var passengersTableView: UITableView!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var joinDeploymentLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let tableViewAdapter = TableViewAdapter<User>()

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
            if data.isUserAPassenger {
                strongSelf.disableButton()
            }

            let deployment = data.deployment
            // TODO: get the user from a user id
            strongSelf.organiserLabel.text = "Organiser: \(deployment.ownerId)"
            strongSelf.titleLabel.text = deployment.name
            strongSelf.tableViewAdapter.update(with: data.passengers)
            strongSelf.passengersTableView.reloadData()
        }

        passengersTableView.dataSource = tableViewAdapter
        passengersTableView.delegate = tableViewAdapter
        activityIndicator.isHidden = true

        tableViewAdapter.cellFactory = { (tableView, indexPath, cellData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = cellData.userName
            return cell
        }

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.joinPressed))
        joinDeploymentButtonView.addGestureRecognizer(gesture)

        viewModel.joinDeploymentRequestCompleted = { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.isHidden = true
            strongSelf.joinDeploymentLabel.isHidden = false
        }
    }

    private func disableButton() {
        joinDeploymentButtonView.backgroundColor = UIColor.gray
        joinDeploymentButtonView.isUserInteractionEnabled = false
    }

    @objc func joinPressed(sender: UITapGestureRecognizer) {
        viewModel.joinDeployment()
        activityIndicator.isHidden = false
        joinDeploymentLabel.isHidden = true
    }
    
    @IBAction func openChatRoom(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "showChat", sender: self)
        
        let user = ATCUser(firstName: "Test F", lastName: "Test L")
        let channel = ATCChatChannel(id: "idc", name: "Group Test")
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let vc = ATCChatThreadViewController(user: user, channel: channel, uiConfig: uiConfig)
        navigationController?.pushViewController(vc, animated: true)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

       
        if segue.identifier == "showChat" {
            let user = ATCUser(firstName: "Test F", lastName: "Test L")
            let channel = ATCChatChannel(id: "idc", name: "Group Test")
            let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                                  secondaryColor: UIColor(hexString: "#f0f0f0"),
                                                  inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                                  inputTextViewTextColor: .black,
                                                  inputPlaceholderTextColor: UIColor(hexString: "#979797"))
            let vc = ATCChatThreadViewController(user: user, channel: channel, uiConfig: uiConfig)
            return
        }
    }

}

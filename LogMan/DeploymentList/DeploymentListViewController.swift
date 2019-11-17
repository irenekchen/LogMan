//
//  DeploymentListViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SnapKit

class DeploymentListViewController: ViewController<DeploymentListViewModel> {

    @IBOutlet weak var tableView: UITableView!
    private var selectedDeployment: Deployment?
    private var selectedDeploymentReference: DocumentReference?

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
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
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        navigationController?.pushViewController(LoginVC, animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    @objc func addPressed(sender:UITapGestureRecognizer){
        let user = ATCUser(firstName: "Test F", lastName: "Test L")
        let channel = ATCChatChannel(id: "idc", name: "Group Test")
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let vc = ATCChatThreadViewController(user: user, channel: channel, uiConfig: uiConfig)
        navigationController?.pushViewController(vc, animated: true)
        //performSegue(withIdentifier: "showChat", sender: self)
    }
    
    @IBAction func openChatRoom(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showDetail", sender: self)
        /*
        let user = ATCUser(firstName: "Test F", lastName: "Test L")
        let channel = ATCChatChannel(id: "idc", name: "Group Test")
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let vc = ATCChatThreadViewController(user: user, channel: channel, uiConfig: uiConfig)
        navigationController?.pushViewController(vc, animated: true)*/
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "showDetail" {
            let detailViewModel = DeploymentDetailViewModel(viewData: DeploymentDetailViewData(deployment: selectedDeployment!, deploymentReference: selectedDeploymentReference!, passengers: [], isUserAPassenger: false))
            let vc = segue.destination as? DeploymentDetailViewController
            vc?.viewModel = detailViewModel
            return
        }
        
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


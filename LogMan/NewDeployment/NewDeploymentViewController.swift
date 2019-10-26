//
//  NewDeploymentViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import UIKit

class NewDeploymentViewController: ViewController<NewDeploymentViewModel> {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createDeploymentButton: UIView!
    @IBOutlet weak var nameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addPressed))
        createDeploymentButton.addGestureRecognizer(gesture)

        viewModel.newDeploymentRequestCompleted = { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.activityIndicator.isHidden = true
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }

    @objc func addPressed() {
        createDeploymentButton.isHidden = true
        activityIndicator.tintColor = .black
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        viewModel.saveNewDeployment(name: nameField.text ?? "")
    }
}

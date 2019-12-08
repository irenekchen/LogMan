//
//  LoginViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import UIKit
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser != nil {
            showList()
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
            let providers: [FUIAuthProvider] = [
                FUIGoogleAuth()]

            authUI?.providers = providers

            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        let deviceToken = UserDefaults.standard.string(forKey: Keys.deviceToken.rawValue)
        // check that the user doesn't already exist!
        DeploymentService().saveNewUser(deviceToken: deviceToken, callback: nil)
        showList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard
            let viewController = segue.destination as? DeploymentListViewController
            else { return }

        viewController.viewModel = DeploymentListViewModel(viewData: DeploymentListViewData(deployments: []))
    }

    private func showList() {
        performSegue(withIdentifier: "showList", sender: self)
    }
}


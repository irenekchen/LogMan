//
//  NewDeploymentViewModel.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

class NewDeploymentViewModel {

    var newDeploymentRequestCompleted: ((_ success: Bool) -> Void)?

    func saveNewDeployment(name: String, time: Date, place: String) {
        //let timestamp = FirTimestampModel(timestamp: Timestamp(date: Date()))
        //let data = try! FirestoreEncoder().encode(timestamp)
        
        let newDeployment = try! FirestoreEncoder().encode(Deployment(ownerId: (Auth.auth().currentUser?.uid)!, name: name, place: place, time: Timestamp(date: time)))

        let firestore = Firestore.firestore()
        let deploymentCollection = firestore.collection("DeploymentPlan")

        let newDeploymentReference = deploymentCollection.document()

        firestore.runTransaction( { (transaction, errorPointer) -> Any in
            transaction.setData(newDeployment, forDocument: newDeploymentReference)
        }) { [weak self] (object, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
                strongSelf.newDeploymentRequestCompleted?(false)
                return
            }

            strongSelf.newDeploymentRequestCompleted?(true)
        }
    }

    private func getCurrentUserName() -> String {
        let user = Auth.auth().currentUser
        return user?.displayName ?? ""
    }
}

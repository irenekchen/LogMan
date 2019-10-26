//
//  DeploymentService.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import Foundation
import FirebaseFirestore
import CodableFirebase
import FirebaseAuth

struct User: Codable {
    var userId: String?
    var userName: String
    var deviceToken: String? = ""
}

class DeploymentService {
    func saveNewUser(deviceToken: String?, callback: ((_ success: Bool) -> Void)?) {
        let userName = getCurrentUserName()
        let userId = Auth.auth().currentUser?.uid
        let newUser = try! FirestoreEncoder().encode(User(userId: userId, userName: userName, deviceToken: deviceToken))
        
        let firestore = Firestore.firestore()
        let userCollection = firestore.collection("users")
        
        let newUserReference = userCollection.document()
        
        firestore.runTransaction( { (transaction, errorPointer) -> Any in
            transaction.setData(newUser, forDocument: newUserReference)
        }) { (object, error) in
            if error != nil {
                callback?(false)
                return
            }
            
            callback?(true)
        }
    }
    
    func saveNewDeployment(name: String, callback: @escaping ((_ success: Bool) -> Void)) {
        let instance = Deployment(ownerId: (Auth.auth().currentUser?.uid)!, name: name)
        let newDeployment = try! FirestoreEncoder().encode(instance)
        
        let firestore = Firestore.firestore()
        let deploymentCollection = firestore.collection("deloyments")
        
        let newDeploymentReference = deploymentCollection.document()
        
        firestore.runTransaction( { (transaction, errorPointer) -> Any in
            transaction.setData(newDeployment, forDocument: newDeploymentReference)
        }) { (object, error) in
            if let error = error {
                print(error)
                callback(false)
                return
            }
            
            callback(true)
        }
    }
    
    private func getCurrentUserName() -> String {
        let user = Auth.auth().currentUser
        return user?.displayName ?? ""
    }
}

//
//  DeploymentDetailViewModel.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase




class DeploymentDetailViewModel {
    var didChangeData: ((DeploymentDetailViewData) -> Void)?
    var deploymentReference: DocumentReference?
    var joinDeploymentRequestCompleted: ((_ success: Bool) -> Void)?

    fileprivate var query: CollectionReference? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }

    private var listener: ListenerRegistration?
    var documents: [DocumentSnapshot] = []

    var viewData: DeploymentDetailViewData {
        didSet {
            didChangeData?(viewData)
        }
    }

    init(viewData: DeploymentDetailViewData) {
        self.viewData = viewData
        self.deploymentReference = viewData.deploymentReference
        query = baseQuery()
    }

    func ready() {
        didChangeData?(viewData)
    }

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }

            let models = snapshot.documents.compactMap { (document) -> User? in
                do {
                    let model = try FirestoreDecoder().decode(User.self, from: document.data())
                    return model
                } catch {
                    print("error parsing document: \(document.data())")
                    return nil
                }
            }

            self.viewData.passengers = models
            self.canTheUserJoinTheDeployment()
            self.documents = snapshot.documents
        }
    }

    func stopObserving() {
        listener?.remove()
    }

    fileprivate func baseQuery() -> CollectionReference? {
        return deploymentReference?.collection("passengers")
    }

    func joinDeployment() {
        guard let query = query else { return }

        let user = Auth.auth().currentUser
        let name = user?.displayName ?? ""

        let passenger = try! FirestoreEncoder().encode(User(userId: user?.uid, userName: (user?.displayName)!, deviceToken: nil))

        let newPassengerReference = query.document()

        Firestore.firestore().runTransaction( { (transaction, errorPointer) -> Any in
            transaction.setData(passenger, forDocument: newPassengerReference)
        }) { [weak self] (object, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
                strongSelf.joinDeploymentRequestCompleted?(false)
                return
            }

            strongSelf.joinDeploymentRequestCompleted?(true)
        }
    }
    
    // TODO: need to fix this after authentication
    private func canTheUserJoinTheDeployment() {
        let userId = Auth.auth().currentUser?.uid
        let ownerId = viewData.deployment.ownerId
        
        let users = viewData.passengers.filter({ passenger in
            return passenger.userId == userId || passenger.userId == ownerId
        })
        
        viewData.isUserAPassenger = users.count == 1
    }

    private func getCurrentUserName() -> String {
        let user = Auth.auth().currentUser
        return user?.displayName ?? ""
    }
}


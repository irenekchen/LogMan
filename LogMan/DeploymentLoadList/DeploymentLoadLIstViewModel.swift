//
//  DeploymentLoadLIstViewModel.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

class DeploymentLoadListViewModel {
    var didChangeData: ((DeploymentLoadListViewData) -> Void)?
    var deploymentLoadListReference: DocumentReference?
    //var joinDeploymentRequestCompleted: ((_ success: Bool) -> Void)?
    var addToDeploymentLoadListRequestCompleted: ((_ success: Bool) -> Void)?

    
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

    var viewData: DeploymentLoadListViewData {
        didSet {
            didChangeData?(viewData)
        }
    }

    init(viewData: DeploymentLoadListViewData) {
        self.viewData = viewData
        self.deploymentLoadListReference = viewData.deploymentLoadListReference
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

            let models = snapshot.documents.compactMap { (document) -> Item? in
                do {
                    let model = try FirestoreDecoder().decode(Item.self, from: document.data())
                    return model
                } catch {
                    print("error parsing document: \(document.data())")
                    return nil
                }
            }

            self.viewData.loadList = models
            self.documents = snapshot.documents
        }
    }

    func stopObserving() {
        listener?.remove()
    }

    fileprivate func baseQuery() -> CollectionReference? {
        return deploymentLoadListReference?.collection("LoadList")
    }
/*
    // create cargo encodable
    func addToDeployment() {
        guard let query = query else { return }

        //let user = Auth.auth().currentUser
        //let name = user?.displayName ?? ""

        let passenger = try! FirestoreEncoder().encode(User(userId: user?.uid, userName: (user?.displayName)!, deviceToken: nil))

        let newPassengerReference = query.document()

        Firestore.firestore().runTransaction( { (transaction, errorPointer) -> Any in
            transaction.setData(passenger, forDocument: newPassengerReference)
        }) { [weak self] (object, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
                strongSelf.addToDeploymentRequestCompleted?(false)
                return
            }

            strongSelf.joinDeploymentRequestCompleted?(true)
        }
    }
    
*/
}

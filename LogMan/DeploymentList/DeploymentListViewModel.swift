//
//  DeplomentListViewModel.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import Foundation
import FirebaseFirestore
import CodableFirebase

class DeploymentListViewModel {
    var deploymentsReference: DocumentReference?

    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }

    private var listener: ListenerRegistration?
    var documents: [DocumentSnapshot] = []
    var didChangeData: ((DeploymentListViewData) -> Void)?

    var viewData: DeploymentListViewData {
        didSet {
            didChangeData?(viewData)
        }
    }

    init(viewData: DeploymentListViewData) {
        self.viewData = viewData
        query = baseQuery()
    }

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in

            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }

            let models = snapshot.documents.compactMap { (document) -> Deployment? in
                do {
                    let model = try FirestoreDecoder().decode(Deployment.self, from: document.data())
                    return model
                } catch {
                    print("error parsing document: \(document.data())")
                    return nil
                }
            }
            self.viewData.deployments = models
            self.documents = snapshot.documents
        }
    }

    func stopObserving() {
        listener?.remove()
    }

    fileprivate func baseQuery() -> Query {
        let docRef = Firestore.firestore().collection("DeploymentPlan").document("SkznZHLy6YImq2PuW6mp")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        print(Firestore.firestore().collection("DeploymentPlan").limit(to: 50))
        return Firestore.firestore().collection("DeploymentPlan").limit(to: 50)
    }
}

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
/*
enum DocumentSnapshotExtensionError:Error {
    case decodingError
}

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        print("decoding snapshot for ", T.self)
        do {
            guard var documentJson = self.data() else {throw DocumentSnapshotExtensionError.decodingError}
            if includingId {
                print("setting ID on document to", self.documentID)
                documentJson["id"] = self.documentID
            }
            
            //transform any values in the data object as needed
            documentJson.forEach { (key: String, value: Any) in
                switch value{
                case let ref as DocumentReference:
                    print("document ref path", ref.path)
                    documentJson.removeValue(forKey: key)
                    break
                case let ts as Timestamp: //convert timestamp to date value
                    print("converting timestamp to date for field \(key)")
                    let date = ts.dateValue()
                    
                    let jsonValue = Int((date.timeIntervalSince1970 * 1000).rounded())
                    documentJson[key] = jsonValue
                    
                    print("set \(key) to \(jsonValue)")
                    break
                default:
                    break
                }
            }
            
            print("getting doucument data")
            let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
            print("Got document data, decoding into object", documentData)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            let decodedObject = try decoder.decode(objectType, from: documentData)
            print("finished decoding DocumentSnapshot", decodedObject)
            return decodedObject
        } catch {
            print("failed to decode", error)
            throw error
        }
        
    }
}
*/

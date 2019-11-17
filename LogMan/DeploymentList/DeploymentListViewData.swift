//
//  DeploymentListViewData.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct Deployment: Codable {
    
    var ownerId: String
    var name: String
    var place: String
    var time: Timestamp

    var dictionary: [String: Any] {
        return [
            "ownerId": ownerId,
            "name": name,
            "place": place,
            "time": time
        ]
    }
}

extension Timestamp: TimestampType {}
/*
extension Deployment: DocumentSerializable {

    init?(dictionary: [String : Any]) {
        guard let owner = dictionary["ownerId"] as? String,
            let place = dictionary["place"] as? String,
            let time = dictionary["time"] as? Date,
            let name = dictionary["name"] as? String
            else { return nil }

        self.init(ownerId: owner, name: name, place: place, time: time)
    }
}
*/




struct DeploymentListViewData {
    var deployments: [Deployment]
}

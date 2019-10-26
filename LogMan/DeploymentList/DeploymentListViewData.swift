//
//  DeploymentListViewData.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation

struct Deployment: Codable {
    var ownerId: String
    var name: String

    var dictionary: [String: Any] {
        return [
            "ownerId": ownerId,
            "name": name,
        ]
    }
}
/*
extension Deployment: DocumentSerializable {

    init?(dictionary: [String : Any]) {
        guard let owner = dictionary["ownerId"] as? String,
            let name = dictionary["name"] as? String,
            else { return nil }

        self.init(ownerId: owner, name: name)
    }
}

*/




struct DeploymentListViewData {
    var deployments: [Deployment]
}

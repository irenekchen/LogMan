//
//  DeploymentLoadListViewData.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct DeploymentLoadListViewData {
    var deployment: Deployment
    var deploymentLoadListReference: DocumentReference
    var loadList: [Item]
}

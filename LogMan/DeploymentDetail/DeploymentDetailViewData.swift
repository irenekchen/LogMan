//
//  DeploymentDetailViewData.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import Foundation
import FirebaseFirestore

struct DeploymentDetailViewData {
    var deployment: Deployment
    var deploymentReference: DocumentReference
    var passengers: [User]
    var isUserAPassenger: Bool = false
}

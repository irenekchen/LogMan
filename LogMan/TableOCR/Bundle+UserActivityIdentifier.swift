//
//  File.swift
//  LogMan
//
//  Created by Irene Chen on 12/6/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation

extension Bundle {
    var userActivityIdentifier: String {
        guard let nsUserActivityTypes = object(forInfoDictionaryKey: "NSUserActivityTypes") as? [String],
            let activityId = nsUserActivityTypes.first else {
            fatalError("Need to declare at least one NSUserActivityTypes in your info.plist")
        }
        return activityId
    }
}

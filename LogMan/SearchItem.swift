//
//  SearchItem.swift
//  LogMan
//
//  Created by Irene Chen on 10/15/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import Foundation

class SearchItem {
    var attributedCargoName: NSMutableAttributedString?
    var attributedCargoProductCode: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var cargoName: String
    var cargoProductCode: String
    
    public init(cargoName: String, cargoProductCode: String) {
        self.cargoName = cargoName
        self.cargoProductCode = cargoProductCode
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedCargoName!)
        allAttributedName!.append(NSMutableAttributedString(string: ", "))
        allAttributedName!.append(attributedCargoProductCode!)
        
        return allAttributedName!
    }
    
    public func getCargoText() -> String{
        return "\(cargoName)"
    }
    
    public func getStringText() -> String{
        return "\(cargoName), \(cargoProductCode)"
    }
    
}


//
//  ViewController+Ext.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import Foundation
import UIKit

public class ViewController<T>: UIViewController {
    var viewModel: T!

    override public func viewDidLoad() {
        super.viewDidLoad()
        assertViewModel()
    }
}

private extension ViewController {
    func assertViewModel() {
        assert(viewModel != nil)
    }
}

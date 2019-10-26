//
//  TableViewAdapter.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit

class TableViewAdapter<T>: NSObject, UITableViewDataSource, UITableViewDelegate {

    typealias CellFactory = (UITableView, IndexPath, T) -> UITableViewCell

    var cellFactory: CellFactory!
    var didSelectItem: ((T, IndexPath) -> Void)?

    var data: [T] = []

    func update(with data: [T]) {
        self.data = data
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = data[indexPath.row]
        return cellFactory(tableView, indexPath, cellData)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = data[indexPath.row]
        didSelectItem?(cellData, indexPath)
    }
}

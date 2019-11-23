//
//  CustomSearchTextField.swift
//  LogMan
//
//  Created by Irene Chen on 10/15/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import UIKit
import CoreData

class CustomSearchTextField: UITextField{
    
    var dataList : [Cargos] = [Cargos]()
    var resultsList : [SearchItem] = [SearchItem]()
    var tableView: UITableView?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        
    }

    
    @objc open func textFieldDidChange(){
        filter()
        updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")
        
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }

    // MARK: CoreData manipulation methods
    
    // Don't need this function in this case
    func saveItems() {
        print("Saving items")
        do {
            try context.save()
        } catch {
            print("Error while saving items: \(error)")
        }
    }
    
    func loadItems(withRequest request : NSFetchRequest<Cargos>) {
        print("loading items")
        do {
            dataList = try context.fetch(request)
        } catch {
            print("Error while fetching data: \(error)")
        }
    }
    
    
    // MARK: Filtering methods
    
    fileprivate func filter() {
        let predicate = NSPredicate(format: "cargoName CONTAINS[cd] %@", self.text!)
        let request : NSFetchRequest<Cargos> = Cargos.fetchRequest()
        request.predicate = predicate
        
        loadItems(withRequest : request)
        
        resultsList = []
        
        for i in 0 ..< dataList.count {
            
            let item = SearchItem(cargoName: dataList[i].cargoName!,cargoProductCode: dataList[i].cargoProductCode!)
            
            let cargoFilterRange = (item.cargoName as NSString).range(of: text!, options: .caseInsensitive)
            let countryFilterRange = (item.cargoProductCode as NSString).range(of: text!, options: .caseInsensitive)
            
            if cargoFilterRange.location != NSNotFound {
                item.attributedCargoName = NSMutableAttributedString(string: item.cargoName)
                item.attributedCargoProductCode = NSMutableAttributedString(string: item.cargoProductCode)
                
                item.attributedCargoName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: cargoFilterRange)
                if countryFilterRange.location != NSNotFound {
                    item.attributedCargoProductCode!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
                }
                
                resultsList.append(item)
            }
            
        }
        
        tableView?.reloadData()
    }
    
    
}

extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: TableView creation and updating
    
    // Create SearchTableview
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
            
        } else {
            addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(resultsList.count)
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = resultsList[indexPath.row].getFormatedText()
        cell.imageView?.image = UIImage(named: resultsList[indexPath.row].getCargoText())
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.text = resultsList[indexPath.row].getStringText()
        tableView.isHidden = true
        //self.endEditing(true)
        
    }
    
    
    // MARK: Early testing methods
    func addData() {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cargos")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
        let hammer = Cargos(context: context)
        hammer.cargoName = "Hammer"
        hammer.cargoProductCode = "UPC-654207165712"
        let tank = Cargos(context: context)
        tank.cargoName = "Tank"
        tank.cargoProductCode = "EAN-4895135119798"
        let knife = Cargos(context: context)
        knife.cargoName = "Swiss Army Knife"
        knife.cargoProductCode = "UPC-046928571314"
        let airTank = Cargos(context: context)
        airTank.cargoName = "Air Compressor Tank"
        airTank.cargoProductCode = "UPC-818223185547"
        let medkit = Cargos(context: context)
        medkit.cargoName = "Medical Kit"
        medkit.cargoProductCode = "UPC-885377270375"
        let cords = Cargos(context: context)
        cords.cargoName = "Parachute Cords"
        cords.cargoProductCode = "UPC-663642551837"
        let steelCable = Cargos(context: context)
        steelCable.cargoName = "Steel Winch Cable"
        steelCable.cargoProductCode = "UPC-779422740930"
        let usbCable = Cargos(context: context)
        usbCable.cargoName = "USB Cable"
        usbCable.cargoProductCode = "EAN-7427046170710"
        let ethernetCable = Cargos(context: context)
        ethernetCable.cargoName = "Ethernet Cable"
        ethernetCable.cargoProductCode = "UPC-818267354213"
        
        saveItems()
        
        dataList.append(hammer)
        dataList.append(tank)
        dataList.append(knife)
        dataList.append(airTank)
        dataList.append(medkit)
        dataList.append(cords)
        dataList.append(steelCable)
        dataList.append(usbCable)
        dataList.append(ethernetCable)
    }
    
}

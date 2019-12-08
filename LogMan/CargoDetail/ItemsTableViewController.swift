//
//  ItemsTableViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/14/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FirebaseUI

class ItemsTableViewController: UITableViewController, DocumentTilerViewControllerDelegate {
    
    // MARK: - Properties
    var cargoNames : [String] = [String]()
    var dataSource : [CargoDetailTableViewCellContent] = [CargoDetailTableViewCellContent]()
    var editIndex:Int?
    var priorityForCargo:[String:Int] = [String:Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cargoNames = ["Hammer, UPC-654207165712", "Tank, EAN-4895135119798", "Air Compressor Tank, UPC-818223185547"]
        dataSource = [CargoDetailTableViewCellContent(name: "Hammer, UPC-654207165712"), CargoDetailTableViewCellContent(name: "Tank, EAN-4895135119798"), CargoDetailTableViewCellContent(name: "Air Compressor Tank, UPC-818223185547")]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkg3")!)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: UIImage(named: "bkg3")!)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = NSLocalizedString("  Deployment Plan C465", comment: "  Plan C456")
            case 1:
                sectionName = NSLocalizedString("  Deployment Plan A106", comment: "  Plan A106")
            // ...
            default:
                sectionName = ""
        }
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
        
            //headerView.backgroundColor = UIColor.lightGray

            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
                tableView.bounds.size.width+32, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
            headerLabel.textColor = UIColor.white
        headerLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
        

            return headerView
        }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cargoNames.count //resultsController.sections?[section].objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CargoItem", for: indexPath) as! CargoDetailTableViewCell

        // Configure the cell...
        //let cargoName : String = cargoNames[indexPath.row]
        //let cargoData = cargoName.components(separatedBy: ", ")
        //cell.textLabel?.text = cargoData[0]
        //cell.imageView?.image = UIImage(named: "\(cargoData[0])")
        //cell.detailTextLabel?.text = cargoData[1]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CargoDetailTableViewCell.self), for: indexPath) as! ExpandingTableViewCell
        cell.set(content: dataSource[indexPath.row])
        //cell.imageView?.image = UIImage(named: "\(cargoData[0])")

        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.cargoNames.remove(at: indexPath.row)
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.cargoNames)
            completion(true)
        }
        
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "Trash")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            self.editIndex = indexPath.row
            self.performSegue(withIdentifier: "editItem", sender: action)
            completion(true)
        }
        
        editAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "Edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            self.cargoNames.remove(at: indexPath.row)
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.cargoNames)
            completion(true)
        }
        action.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "Check")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _ = sender as? UIButton, let destVC = segue.destination as? AddItemViewController {
            destVC.currentIndexPath = -1
            navigationController?.navigationBar.backgroundColor = .none

        } else if let _ = sender as? UIContextualAction, let destVC = segue.destination as? AddItemViewController {
            let rowClicked = self.editIndex!
            let destVC = segue.destination as! AddItemViewController
            destVC.currentIndexPath = rowClicked
            print(cargoNames, rowClicked, cargoNames[rowClicked])
            destVC.currentTextFieldName = cargoNames[rowClicked]
              destVC.currentPriority = priorityForCargo[cargoNames[rowClicked]] ?? 0
        } else if let _ = sender as? UIButton, let vc = segue.destination as? CargoDetectionViewController {
            vc.navigationController?.navigationBar.backgroundColor = .none
        //} else //if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? DocumentScannerViewController {
            //vc.openDocumentScanner()
        } else if let vc = segue.destination as? DocumentTilerViewController{
            vc.delegate = self
            for name in vc.detectedNomenclature {
                let NSN = vc.catalogDictionary[name]
                //vc.importContext.append("\(name), \(NSN)")
                self.cargoNames.append("\(name), \(NSN)")
                self.dataSource.append(CargoDetailTableViewCellContent(name: "\(name), \(NSN)"))

            }
            self.tableView.reloadData()

            //aViewController.cargoNames = self.importContext
        }
        //addOrSubtractMoneyVC.dailyBudgetPassedThrough = userDailyBudgetPassedOver
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let detailVC = segue.source as! AddItemViewController
               tableView.reloadData()
    }
        
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = dataSource[indexPath.row]
        //content.expanded = !content.expanded
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func scanTable(_ sender: Any) {
        let userActivity = NSUserActivity()
        if #available(iOS 12.0, *) {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = DocumentScannerViewController()
            navigationController?.pushViewController(vc, animated: true)
            //let viewController = storyboard.instantiateViewController(withIdentifier: "DocumentScanner") as! DocumentScannerViewController
        //navigationController?.pushViewController(viewController, animated: true)
        
        
            vc.openDocumentScanner()
        }
        
        
    }
    
    func childViewControllerResponse(parameter detectedNomenclature: [String], parameter2 catalogDictionary: [String:String])
    {
       for name in detectedNomenclature {
           let NSN = catalogDictionary[name]
           //vc.importContext.append("\(name), \(NSN)")
           self.cargoNames.append("\(name), \(NSN)")
           self.dataSource.append(CargoDetailTableViewCellContent(name: "\(name), \(NSN)"))

       }
       self.tableView.reloadData()
    }

    
    

}

extension UITableViewRowAction {

  func setIcon(iconImage: UIImage, backColor: UIColor, cellHeight: CGFloat, iconSizePercentage: CGFloat)
  {
    let iconHeight = cellHeight * iconSizePercentage
    let margin = (cellHeight - iconHeight) / 2 as CGFloat

    UIGraphicsBeginImageContextWithOptions(CGSize(width: cellHeight, height: cellHeight), false, 0)
    let context = UIGraphicsGetCurrentContext()

    backColor.setFill()
    context!.fill(CGRect(x:0, y:0, width:cellHeight, height:cellHeight))

    iconImage.draw(in: CGRect(x: margin+10.0, y: margin+10, width: iconHeight-20, height: iconHeight-20))

    let actionImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.backgroundColor = UIColor.init(patternImage: self.imageWithImage(image: UIImage(named: "Trash")!, scaledToSize: CGSize(width: iconHeight*1.5, height: iconHeight*1.5)))
  }

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    
}

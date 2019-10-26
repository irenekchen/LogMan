//
//  AddItemViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/14/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var cargoNamesArray:[String]!
    var currentTextFieldName: String = ""
    var currentIndexPath: Int = -1
    var currentPriority = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AddItemViewController.keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkg2")!)
        textView.becomeFirstResponder()
        textView.text = self.currentTextFieldName
        segmentedControl.selectedSegmentIndex = currentPriority
    }
    
    // MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
    
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        textView.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        //let mainVC = segue.source as! ItemsTableViewController
        
        //let index = detailViewController.index
        
        //let modelString = detailViewController.editedModel
        
        //cargoNamesArray.append(textView.text ?? "")
        
        //tableView.reloadData()
        //let detailVC = segue.source as! AddItemViewController
        
        dismiss(animated: true)
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        textView.resignFirstResponder()
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done" {
            name = textView.text!
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*
        if segue.identifier == "done" {
            let detailVC = segue.source as! AddItemViewController
            
               //let index = detailViewController.index
            
               //let modelString = detailViewController.editedModel
                cargoNames.append(detailVC.textView.text ?? "")
            
               tableView.reloadData()
        }*/
        if let _ = sender as? UIButton, let vc = segue.destination as? ItemsTableViewController {
            currentTextFieldName = textView.text!
            if self.currentIndexPath == -1 {
                vc.cargoNames.append(currentTextFieldName)
                vc.dataSource.append(CargoDetailTableViewCellContent(name: currentTextFieldName))
            } else {
                vc.cargoNames[self.currentIndexPath] = currentTextFieldName
                vc.dataSource[self.currentIndexPath] = CargoDetailTableViewCellContent(name: currentTextFieldName)
            }
            vc.priorityForCargo[currentTextFieldName] = segmentedControl.selectedSegmentIndex
            vc.tableView.reloadData()
            
        }
    }
    /*
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {

        //code

    }
    */
    /*
    func add(){
     guard let title = textView.text, !title.isEmpty else {
         return
     }
     let cargo = Cargo(context: managedContext)
     cargo.title = title
     cargo.priority = Int16(segmentedControl.selectedSegmentIndex)
     do {
         try { managedContext.save()
         dismiss(animated:true)
         textView.resignFirstResponder()
         } catch {
             print("Error saving todo: \(error)")
         }
     }
     }
     */
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textView: UITextField) {
        if doneButton.isHidden {
            //textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded()
            })
        }
    }
}

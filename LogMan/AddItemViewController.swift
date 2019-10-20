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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AddItemViewController.keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        textView.becomeFirstResponder()
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
        textView.resignFirstResponder()
    }
    @IBAction func done(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
    
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
            textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded()
            })
        }
    }
}

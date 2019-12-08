//
//  CargoDetailTableViewCell.swift
//  LogMan
//
//  Created by Irene Chen on 10/22/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit

class CargoDetailTableViewCellContent {
    
    var title: String?
    var subtitle: String?
    var expanded: Bool

    init(name: String) {
        
        //let cargoName : String = cargoNames[indexPath.row]
        let cargoData = name.components(separatedBy: ", ")
        //cell.textLabel?.text = cargoData[0]
        //cell.imageView?.image = UIImage(named: "\(cargoData[0])")
        //cell.detailTextLabel?.text = cargoData[1]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CargoDetailTableViewCell.self), for: indexPath) as! ExpandingTableViewCell
        self.title = cargoData[0]
        self.subtitle = cargoData[1]
        self.expanded = false
        
    }
}

class CargoDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var cargoImage: UIImageView!
    //@IBOutlet weak var detailStackView: UIStackView!
    
    @IBOutlet weak var detailStackView: UIView! {
        didSet {
            detailStackView.isHidden = false
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(content: CargoDetailTableViewCellContent) {
        self.titleLabel.text = content.title
        //self.subtitleLabel.text = content.expanded ? content.subtitle : ""
        self.subtitleLabel.text = content.subtitle
        self.cargoImage.image = UIImage(named: content.title!)
        //self.layoutImageView(content: content)
        self.detailStackView.isHidden = !self.detailStackView.isHidden
        
    }
    
    func layoutImageView(content: CargoDetailTableViewCellContent) {
        if content.expanded {
            //self.cargoImage.image = nil

            self.imageHeight.constant = 0
            self.titleHeight.constant = 50
            self.titleLabel.font = self.titleLabel.font.withSize(35)
            UITableView.animate(withDuration: 2) {
                self.layoutSubviews()
            }
            /*UITableView.animate(withDuration: 2) {
                    self.imageHeight.constant = 50

                self.layoutIfNeeded()
                }*/
            
        }
        else {
            self.imageHeight.constant = 70
            self.titleHeight.constant = 20
                       self.titleLabel.font = self.titleLabel.font.withSize(25)
            UITableView.animate(withDuration: 2) {

                    self.layoutIfNeeded()
                } //self.cargoImage.image = UIImage(named: content.title!)
        }
    }

}

//
//  DeploymentListViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/26/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CodableFirebase
import SnapKit

class DeploymentListViewController: ViewController<DeploymentListViewModel> {

    @IBOutlet weak var tableView: UITableView!
    private var selectedDeployment: Deployment?
    private var selectedDeploymentReference: DocumentReference?

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var createDeploymentButton: UIView!
    private let tableViewAdapter = TableViewAdapter<Deployment>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.didChangeData = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.tableViewAdapter.update(with: data.deployments)
            strongSelf.tableView.reloadData()
        }

        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter
        tableView.estimatedRowHeight = 200
        

        tableViewAdapter.cellFactory = { (tableView, indexPath, cellData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DeploymentTableViewCell else { return UITableViewCell() }
            cell.populate(deployment: cellData)
            return cell
        }

        tableViewAdapter.didSelectItem = { [weak self] rowData, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deselectRow(at: indexPath, animated: true)
            strongSelf.selectedDeployment = rowData
            strongSelf.selectedDeploymentReference = strongSelf.viewModel.documents[indexPath.row].reference
            strongSelf.detailPressed()
        }

        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addPressed))
        createDeploymentButton.addGestureRecognizer(gesture)
    }

    func detailPressed() {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        navigationController?.pushViewController(LoginVC, animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    @objc func addPressed(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "addDeployment", sender: self)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "showDetail" {
            let detailViewModel = DeploymentDetailViewModel(viewData: DeploymentDetailViewData(deployment: selectedDeployment!, deploymentReference: selectedDeploymentReference!, passengers: [], isUserAPassenger: false))
            let vc = segue.destination as? DeploymentDetailViewController
            vc?.viewModel = detailViewModel
            return
        }

        guard
            let viewController = segue.destination as? NewDeploymentViewController
            else { return }

        viewController.viewModel = NewDeploymentViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.observeQuery()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObserving()
    }

    deinit {
        viewModel.stopObserving()
    }
}

class DeploymentTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var deploymentIcon: UIImageView!
    @IBOutlet weak var deploymentNameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!

    func populate(deployment: Deployment) {
        organiserLabel.text = deployment.ownerId
        deploymentNameLabel.text = deployment.name
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .none
        //dateFormatter.timeStyle = .short
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"


        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = NSLocale.current
        //let currDateEST = Calendar.current.date(byAdding: .hour, value: -5, to: deployment.time.dateValue())

        //let curr = formatter.date(from: deployment.time.dateValue())
        //let currentDateESTLabel = Calendar.current.date(byAdding: .hour, value: -5, to: currDateEST!)


        // again convert your date to string
        //let myStringafd = formatter.string(from: yourDate!)

        //print(myStringafd)

        //timeLabel.text = formatter.string(from: currentDateESTLabel!)
            //= dateFormatter.string(from: deployment.time)
        timeLabel.text = formatter.string(from: deployment.time.dateValue())
        
        // here we set the current date

        let date = NSDate()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: date as Date)

        let currentDate = calendar.date(from: components)


        
        let currentDateEST = Calendar.current.date(byAdding: .hour, value: -5, to: currentDate!)
        print(currentDateEST!)

        let endDateEST = Calendar.current.date(byAdding: .hour, value: 7, to: deployment.time.dateValue())
        print(endDateEST!)

        
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: endDateEST!, to: currentDateEST!)
        let formattedString = String(format: "%02ld%02ld%02ld", -abs(difference.hour!%12), -abs(difference.minute!), -abs(difference.second!))
        let component = formattedString.split(separator: "-")
        print(component)
        remainingTimeLabel.text = String(format: "%02dhrs %02d%min", Int(component[0])!, Int(component[1])!)
        print(formattedString)
        //let formattedString2 = String(format: "%02ld%02ld%02ld", difference.hour!, difference.minute!, difference.second!)
        //print(formattedString2)

        /*let userCalendar = Calendar.current
        
        let completionDate = deployment.time.dateValue() as Date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: completionDate)
        //print(formattedDate)

        let calendar = Calendar.current
        calendar.component(.year, from: date)
        calendar.component(.month, from: date)
        calendar.component(.day, from: date)

            // here we set the due date. When the timer is supposed to finish
        var completitionDate = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: deployment.time.dateValue() as Date)
            completitionDate.year = deployment.time.dateValue().year
            completitionDate.month = deployment.time.dateValue().month
            completitionDate.day = 16
            completitionDate.hour = 00
            completitionDate.minute = 00
            let completitionDay = userCalendar.date(from: completitionDate as DateComponents)!

            //here we change the seconds to hours,minutes and days
            let CompetitionDayDifference = calendar.dateComponents([.day, .hour, .minute], from: currentDate!, to: competitionDay)


            //finally, here we set the variable to our remaining time
            let daysLeft = CompetitionDayDifference.day
            let hoursLeft = CompetitionDayDifference.hour
            let minutesLeft = CompetitionDayDifference.minute

            print("day:", daysLeft ?? "N/A", "hour:", hoursLeft ?? "N/A", "minute:", minutesLeft ?? "N/A")

            //Set countdown label text
            countDownLabel.text = "\(daysLeft ?? 0) Days, \(hoursLeft ?? 0) Hours, \(minutesLeft ?? 0) Minutes"
        shareimprove this answer
*/
        
        
    }
}


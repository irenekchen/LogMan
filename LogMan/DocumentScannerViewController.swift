//
//  DocumentScannerViewController.swift
//  LogMan
//
//  Created by Irene Chen on 12/6/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import YesWeScan
import TOCropViewController

class DocumentScannerViewController: UIViewController {
    // MARK: private fields
    private var scannedImage: UIImage? {
        willSet {
            set(isVisible: newValue != nil)
        } didSet {
            imageView.image = scannedImage
        }
    }

    // MARK: IBOutlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var shareButton: UIButton!
    
    

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        set(isVisible: true)
        //addToSiriShortcuts()
        let identifier = Bundle.main.userActivityIdentifier
        let activity = NSUserActivity(activityType: identifier)
        activity.title = "Scan Document"
        activity.userInfo = ["Document Scanner": "open document scanner"]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
        } else {
            // Fallback on earlier versions
        }
        view.userActivity = activity
        activity.becomeCurrent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

       imageView.image = nil
       scannedImage = nil
    }

    private func set(isVisible: Bool) {
        imageView.isHidden = false
        editButton.isHidden = false
        shareButton.isHidden = false
    }
}

extension DocumentScannerViewController: ScannerViewControllerDelegate {
    func scanner(_ scanner: ScannerViewController,
                 didCaptureImage image: UIImage) {

        scannedImage = image
        navigationController?.popViewController(animated: true)
    }
}


extension DocumentScannerViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController,
                            didCropTo image: UIImage,
                            with cropRect: CGRect,
                            angle: Int) {

        scannedImage = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension DocumentScannerViewController {
    @IBAction func scanDocument(_ sender: UIButton) {
        openDocumentScanner()
    }

    @IBAction func editImage(_ sender: UIButton) {
        guard let image = scannedImage
            else { return }

        //let cropViewController = TOCropViewController(image: image)
        //cropViewController.delegate = self
        let vc = DocumentTilerViewController(image:scannedImage!)
            //navigationController?.pushViewController(vc, animated: true)
            //let viewController = storyboard.instantiateViewController(withIdentifier: "DocumentScanner") as! DocumentScannerViewController
        
        
        vc.imageView.image = scannedImage
        navigationController?.pushViewController(vc, animated: true)
        
        
        //present(vc, animated: true)
    }

    @IBAction func actionShare(_ sender: UIButton) {
        guard let image = scannedImage
            else { return }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
}

extension DocumentScannerViewController {
    func addToSiriShortcuts() {
        if #available(iOS 12.0, *) {
            let identifier = Bundle.main.userActivityIdentifier
            let activity = NSUserActivity(activityType: identifier)
            activity.title = "Scan Document"
            activity.userInfo = ["Log Man": "open document scanner"]
            activity.isEligibleForSearch = true
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
            view.userActivity = activity
            activity.becomeCurrent()
        }
    }

    public func openDocumentScanner() {
        let scanner = ScannerViewController()
        scanner.delegate = self
        scanner.scanningQuality = .fast
        navigationController?.pushViewController(scanner, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

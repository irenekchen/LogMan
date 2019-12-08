//
//  DocumentTilerViewController.swift
//  LogMan
//
//  Created by Irene Chen on 12/6/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//


import UIKit
import SwiftyTesseract

class DocumentTilerViewController: UIViewController {
    
    //@IBOutlet weak var imageView: UIImageView? = UIImageView()
    var imageView = UIImageView()
    //var imageName: String = ""
    var maxViews: Int = 0
    
    var detectedLabels: [String] = []
    var detectedNomenclature: [String] = []
    var detectedNSNs: [String] = []
    var importContext: [String] = []


    
    let swiftyTesseract = SwiftyTesseract(language: .english)
    var currentIndexPath = -1
    
    var catalogDictionary : [String:String] = ["Hammer":"UPC-654207165712","Tank":"EAN-4895135119798",
        "Swiss Army Knife":"UPC-046928571314","Air Compressor Tank":"UPC-818223185547",
        "Medical Kit":"UPC-885377270375",
        "Parachute Cords":"UPC-663642551837",
        "Steel Winch Cable":"UPC-779422740930",
        "USB Cable":"EAN-7427046170710",
        "Ethernet Cable":"UPC-818267354213"]
    
    var delegate: DocumentTilerViewControllerDelegate?

    
    public init(image: UIImage) {
        self.imageView.image = image
        //self.imageView.image = image
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    /*
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
        
        //self.imageName = "Small-Table-opti.jpg"
        //let image = UIImage(named: imageName)
        //self.imageView = UIImageView(image: image)
        
        self.imageView.contentMode = .center
        self.imageView.contentMode = .scaleAspectFit
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(self.imageView)
        
        
        
        let halfSizeOfView = 20
        
        self.maxViews = 4
        var bezierPathYMax: CGFloat!

        let insetSize = self.view.bounds.insetBy(dx: CGFloat(Int(2 * halfSizeOfView)), dy: CGFloat(Int(2 * halfSizeOfView))).size
        
        // Add the Views
        for _ in 0..<maxViews {
            let pointX = CGFloat(UInt(arc4random() % UInt32(UInt(insetSize.width))))
            let pointY = CGFloat(-500)
            
            let newView = MyView(frame: CGRect(x: pointX, y: pointY, width: 20, height: 2000))
            self.view.addSubview(newView)
            
            
            
        }
        //swiftOCRInstance.recognize(image!) { recognizedString in
        //    print("I detetcted words! Reading.... \(recognizedString)")
        //}
        /*
        guard let readImage = UIImage(named: "Small-Table-opti.jpg") else { return }
        swiftyTesseract.performOCR(on: readImage) { recognizedString in

          guard let recognizedString = recognizedString else { return }
            print(recognizedString)

        }*/
        
 
    }
    
    
    
    /*
     Draw Bezier Quad curve and get the path.
     */
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        let image = self.imageView.image!
        let imageName = "tiled_image"
        var partitions: [Int] = []

        //print(image.matrix(imageName, self.maxViews).capacity)
        for divider in self.view.subviews{
            if divider.isKind(of: MyView.self) {
                let xPartitionInWindow = divider.convert(divider.bounds, to: self.view)
                partitions.append(Int(xPartitionInWindow.minX))
            }
            //print(xPartitionInWindow.minX)
        }
        partitions.sort()
        partitions.append(Int(self.view.frame.width))
        
        let swiftyTesseract = SwiftyTesseract(language: .english)

        let imagePartitions = image.matrix(imageName, partitions)
        (1..<imagePartitions.count-1).forEach { imageIndex in
        //for image in imagePartitions {
            let image = imagePartitions[imageIndex]
            swiftyTesseract.performOCR(on: image) { recognizedString in

              guard let recognizedString = recognizedString else { return }
                self.detectedLabels.append(recognizedString)
              //detectedrecognizedString)

            }
        }
        //print(self.detectedLabels)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
        for aViewController in viewControllers {
            if(aViewController is ItemsTableViewController){
                for recognizedString in self.detectedLabels {
                    if recognizedString.lowercased().contains("nomenclature") {
                        if let range = recognizedString.range(of: "Nomenclature") {
                            let listOfNomenclature = recognizedString[range.upperBound...].components(separatedBy: "\n")
                            for nomenclature in listOfNomenclature {
                                for key in self.catalogDictionary.keys {
                                    if nomenclature.contains(key) {
                                        self.detectedNomenclature.append(key)
                                    }
                                }
                            }
                        }
                    } else if recognizedString.lowercased().contains("nsn") {
                        if let range = recognizedString.range(of: "NSN") {
                            let phone = recognizedString[range.upperBound...].components(separatedBy: "\n")
                            print(phone) // prints "123.456.7891"
                        }
                    }
                }
                
                if let delegate = delegate{
                    delegate.childViewControllerResponse(parameter: self.detectedNomenclature, parameter2: self.catalogDictionary)
                }
                if let vc = aViewController as? ItemsTableViewController {
                    //vc.cargoNames = self.detectedNomenclature
                    for name in self.detectedNomenclature {
                        let NSN = self.catalogDictionary[name]!
                        //vc.importContext.append("\(name), \(NSN)")
                        vc.cargoNames.append("\(name), \(NSN)")
                        vc.dataSource.append(CargoDetailTableViewCellContent(name: "\(name), \(NSN)"))

                    }
                    vc.tableView.reloadData()
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationController!.popToViewController(vc, animated: true)
                }
                
            
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)

        
        //self.navigationController?.popToRootViewController(animated: true)

            //navigationController?.pushViewController(vc, animated: true)
            //let viewController = storyboard.instantiateViewController(withIdentifier: "DocumentScanner") as! DocumentScannerViewController
        
        
        //vc.imageView.image = scannedImage
        //present(scanner, animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)

        
        
        

        //print(self.view.frame.width)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let _ = sender as? UIButton, let vc = segue.destination as? ItemsTableViewController {
            //currentTextFieldName = textView.text!
            if self.currentIndexPath == -1 {
                
                for name in detectedLabels {
                    vc.cargoNames.append(name)
                    vc.dataSource.append(CargoDetailTableViewCellContent(name: name))
                }
            }
            vc.tableView.reloadData()
            
        }
    }
    


}

extension UIImage {
    
    func matrix(_ imageName: String, _ columns: [Int]) -> [UIImage] {
        var partitions: [Int] = []
        var scaledPartitions: [Int] = []
        var scaledColumns: [Int] = []
        


        partitions.reserveCapacity(columns.count+1)
        partitions.append(columns[0])
        (1..<columns.count).forEach { i in
            let start = columns[i-1]
            let end = columns[i]
            let width = end - start
            partitions.append(width)
        }

        for partition in partitions{
        scaledPartitions.append(Int(CGFloat(partition)/CGFloat(columns[columns.count-1])*self.size.width))
        }
        for column in columns {
            scaledColumns.append(Int(CGFloat(column)/CGFloat(columns[columns.count-1])*self.size.width))
        }
        //print(columns)
        //print(scaledColumns)
        let x = (size.width / CGFloat(columns.count))
        var images: [UIImage] = []
        images.reserveCapacity(columns.count)
        guard let cgImage = cgImage else { return [] }
        (0..<scaledPartitions.count).forEach { i in
            var width = scaledPartitions[i]
            let height = Int((size.height).rounded())
            /*
            if i == partitions.count-1 && size.width.truncatingRemainder(dividingBy: CGFloat(partitions.count)) != 0 {
                width = Int(size.width - (size.width / CGFloat(columns) * (CGFloat(columns)-1)))
            }*/
            let start = (i == 0) ? 0 : scaledColumns[i-1]
            if let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: start, y: 0), size: CGSize(width: width, height: height))) {
                images.append(UIImage(cgImage: image, scale: scale, orientation: imageOrientation))
            }
            
        }
        saveTiles(usingPrefix: (URL(string: imageName)?.deletingPathExtension().absoluteString)!, images: images)
        let swiftyTesseract = SwiftyTesseract(language: .english)

/*
        for image in images {
            swiftyTesseract.performOCR(on: image) { recognizedString in

              guard let recognizedString = recognizedString else { return }
              print(recognizedString)

            }
        }*/
        return images
    }
    
    func saveTiles(usingPrefix prefix: String, images: [UIImage]) {
        let fileManager = FileManager.default
        let directoryURL = fileManager.temporaryDirectory.appendingPathComponent("TileManager", isDirectory: true).appendingPathComponent(prefix, isDirectory: true)
        if !fileManager.fileExists(atPath: directoryURL.path) {
            
            do {
                
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                
            }
            catch let error {
                fatalError("cant create directory at \(directoryURL), cause error: \(error)")
            }
            
        }
            
        autoreleasepool {
            (0..<images.count).forEach { index in
                let image = images[index]
                let imageData = image.jpegData(compressionQuality: 1.0)
                let tileName = "\(prefix)_\(index).jpg"
                let url = directoryURL.appendingPathComponent(tileName)
                do {
                    print(url.absoluteString)
                    

                    try imageData!.write(to: url)
                    print(url.absoluteString)
                }
                catch {
                    print(error)
                    return
                }
            }
            
        }
    }
}
/*
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
*/

protocol DocumentTilerViewControllerDelegate
{
    func childViewControllerResponse(parameter: [String], parameter2: [String:String])
}




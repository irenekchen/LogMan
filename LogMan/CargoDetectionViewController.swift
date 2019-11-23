//
//  CargoDetectionViewController.swift
//  LogMan
//
//  Created by Irene Chen on 10/23/19.
//  Copyright © 2019 Irene Chen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class CargoDetectionViewController: UIViewController, ARSCNViewDelegate {
    
    /*
        // machine learning for object recognition using vision framework
        // Delegtate variables to implement viision framework
        private var detectionOverlay: CALayer! = nil
        
        // vision framework protocol variables
        private var analysisRequests = [VNRequest]()
        private let sequenceRequestHandler = VNSequenceRequestHandler()
        private let maximumHistoryLength = 30
        private var transpositionHistoryPoints: [CGPoint] = [ ]
        private var previousPixelBuffer: CVPixelBuffer?
        
        // keeps track of pixel processing one by one
        private var currentlyAnalyzedPixelBuffer: CVPixelBuffer?
        
        // perform these tasks on background queue
        private let visionQueue = DispatchQueue(label: "com.columbia.ic2409.LogMan.serialVisionQueue")
        var productViewOpen = false
        
        
        // show results:
        fileprivate func showProductInfo(_ identifier: String) {
            DispatchQueue.main.async(execute: {
                if self.productViewOpen {
                    return
                }
                self.productViewOpen = true
                self.performSegue(withIdentifier: "cargoProductLabel", sender: identifier)
            })
        }
        
     
     
        @discardableResult
        func setupVision() -> NSError? {
            let error: NSError! = nil
            let barcodeDetection = VNDetectBarcodesRequest(completionHandler: { (request, error) in
                if let results = request.results as? [VNBarcodeObservation] {
                    if let mainBarcode = results.first {
                        if let payloadString = mainBarcode.payloadStringValue {
                            self.showProductInfo(payloadString)
                        }
                    }
                }
            })
            self.analysisRequests = ([barcodeDetection])
            
            // Need to add training images. todo.
            guard let modelURL = Bundle.main.url(forResource: "cargoMLmodelName", withExtension: "mlmodelc") else {
                return NSError(domain: "CargoDetetctionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "The model file is missing."])
            }
            guard let objectRecognition = createClassificationRequest(modelURL: modelURL) else {
                return NSError(domain: "CargoDetectionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "The classification request failed."])
            }
            self.analysisRequests.append(objectRecognition)
            return error
        }
        
        private func createClassificationRequest(modelURL: URL) -> VNCoreMLRequest? {
            
            do {
                let objectClassifier = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
                let classificationRequest = VNCoreMLRequest(model: objectClassifier, completionHandler: { (request, error) in
                    if let results = request.results as? [VNClassificationObservation] {
                        print("\(results.first!.identifier) : \(results.first!.confidence)")
                        if results.first!.confidence > 0.9 {
                            self.showProductInfo(results.first!.identifier)
                        }
                    }
                })
                return classificationRequest
                
            } catch let error as NSError {
                print("Model failed to load: \(error).")
                return nil
            }
        }
        
        private func analyzeCurrentImage() {
            // Most computer vision tasks are not rotation-agnostic, so it is important to pass in the orientation of the image with respect to device.
            let orientation = exifOrientationFromDeviceOrientation()
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentlyAnalyzedPixelBuffer!, orientation: orientation)
            visionQueue.async {
                do {
                    defer { self.currentlyAnalyzedPixelBuffer = nil }
                    try requestHandler.perform(self.analysisRequests)
                } catch {
                    print("Error: Vision request failed with error \"\(error)\"")
                }
            }
        }
        fileprivate func resetTranspositionHistory() {
            transpositionHistoryPoints.removeAll()
        }
        
        fileprivate func recordTransposition(_ point: CGPoint) {
            transpositionHistoryPoints.append(point)
            
            if transpositionHistoryPoints.count > maximumHistoryLength {
                transpositionHistoryPoints.removeFirst()
            }
        }

        // manhattan dist algorithm to check for distance between frames
        fileprivate func sceneStabilityAchieved() -> Bool {
            if transpositionHistoryPoints.count == maximumHistoryLength {
                var movingAverage: CGPoint = CGPoint.zero
                for currentPoint in transpositionHistoryPoints {
                    movingAverage.x += currentPoint.x
                    movingAverage.y += currentPoint.y
                }
                let distance = abs(movingAverage.x) + abs(movingAverage.y)
                if distance < 30 {
                    return true
                }
            }
            return false
        }
        
        override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            guard previousPixelBuffer != nil else {
                previousPixelBuffer = pixelBuffer
                self.resetTranspositionHistory()
                return
            }
            
            if productViewOpen {
                return
            }
            let registrationRequest = VNTranslationalImageRegistrationRequest(targetedCVPixelBuffer: pixelBuffer)
            do {
                try sequenceRequestHandler.perform([ registrationRequest ], on: previousPixelBuffer!)
            } catch let error as NSError {
                print("Failed to process request: \(error.localizedDescription).")
                return
            }
            
            previousPixelBuffer = pixelBuffer
            
            if let results = registrationRequest.results {
                if let alignmentObservation = results.first as? VNImageTranslationAlignmentObservation {
                    let alignmentTransform = alignmentObservation.alignmentTransform
                    self.recordTransposition(CGPoint(x: alignmentTransform.tx, y: alignmentTransform.ty))
                }
            }
            if self.sceneStabilityAchieved() {
                showDetectionOverlay(true)
                if currentlyAnalyzedPixelBuffer == nil {
                    // Retain the image buffer for Vision processing.
                    currentlyAnalyzedPixelBuffer = pixelBuffer
                    analyzeCurrentImage()
                }
            } else {
                showDetectionOverlay(false)
            }
        }
        
        
        //showLabekHere
        private func showDetectionOverlay(_ visible: Bool) {
            DispatchQueue.main.async(execute: {
                self.detectionOverlay.isHidden = !visible
            })
        }
    */
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.showsStatistics = false
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        sceneView.scene = scene
        //canm see the whole camera view
        navigationController?.navigationBar.backgroundColor = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "ScannedCargoObjects", bundle: Bundle.main)!
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //prepare for background process
        sceneView.session.pause()
    }
    
    
    //WIP when user taps.
    /*
    // explode confetti when user taps.
    private func spawnConfetti() {
      let confetti = SKSpriteNode(texture: nil)
        confetti.physicsBody = SKPhysicsBody(texture: nil, size: confetti.size)
      confetti.position = CGPoint(x: size.width / 2, y: size.height / 2)

      addChild(confetti)
    }
    

    func addConfetti() {
        /*
        objectsLayer.removeChildrenInArray(objectsToRemove)    // remove all Nodes marked for removal
        
        objectsLayer.enumerateChildNodesWithName("confetti", usingBlock: { //TOODO
        )
 */
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {

        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)

        if lemonadeLabel.containsPoint(location) {

            println("add label pressed")
            lemonadeLabel.removeFromParent()
            //TODO:// remove label and add to plan.

        }

    }
*/
    
    /*
      override func touchesBegan(_ touches: Set<UITouch>,
                                 with event: UIEvent?) {
          if let touchLocation = touches.first.location(in: self),
              let node = nodes(at: touchLocation).first {
              
          }
      }
      */
    // MARK: - ARSCNViewDelegate implemenmt protocol methods
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        if let objectAnchor = anchor as? ARObjectAnchor {
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
            
            plane.cornerRadius = plane.width / 8
            
            // show label here
            let spriteKitScene = SKScene(fileNamed: "ObjectLabelScene")
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.35, objectAnchor.referenceObject.center.z)
            
            node.addChildNode(planeNode)
            
        }
        return node
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
    //prepare for adding object to deployment list here
    /*
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))

    //Add recognizer to sceneview
    sceneView.addGestureRecognizer(tapRec)
*/
    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        
           if rec.state == .ended {
                let location: CGPoint = rec.location(in: sceneView)
                let hits = self.sceneView.hitTest(location, options: nil)
                if !hits.isEmpty{
                    let tappedNode = hits.first?.node
                }
           }
    }
  
    


    
}

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

class CargoDetectionViewController: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        sceneView.scene = scene
        navigationController?.navigationBar.backgroundColor = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "ScannedCatalogObjects", bundle: Bundle.main)!
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
            
            plane.cornerRadius = plane.width / 8
            let spriteKitScene = SKScene(fileNamed: "ObjectLabelScene")
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.35, objectAnchor.referenceObject.center.z)

            // adds the node to the scene 
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
    
    // TODO:// these classes are used for later to add tap to add obejct to the deployment list, icnore for now.
    //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))

    //Add recognizer to sceneview
    //sceneView.addGestureRecognizer(tapRec)

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
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        if let touchLocation = touches.first.location(in: self),
            let node = nodes(at: touchLocation).first {
            
        }
    }
  
    // MARK:// Delegate class functions to implement AR protocol
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}

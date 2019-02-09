//
//  ViewController.swift
//  RestaurantArdyia
//
//  Created by Zelal-Ezaldeen on 12/26/18.
//  Copyright © 2018 Metra Company. All rights reserved.
//

import UIKit
import ARKit
import Firebase
import RealmSwift

class RestaurantVC: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {
   // Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var projectARName: UITextField!
    // To track the device in the World
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.registerGestureRecognizers()
        
        projectARName.delegate = self
        playBtn.bindToKeyboard()
        resetBtn.bindToKeyboard()
        locationBtn.bindToKeyboard()
        
    }

    @IBAction func playBtnPressed(_ sender: Any) {
        addNode()
        self.playBtn.isEnabled = false
    }
    
       
    @IBAction func resetBtnPressed(_ sender: Any) {
        self.playBtn.isEnabled = true
        self.projectARName.isHidden = false
        self.projectARName.text = ""
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        //Log out user and send them back to the WelcomeVC
        let logoutPopup = UIAlertController(title: "تسجيل الخروج؟", message: "هل تريد تسجيل الخروج؟", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "تسجيل الخروج؟", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: AUTH_VC) as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
            
        }
      logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    func addNode() {
       let projectName = projectARName.text!
       let restaurantArdiyaScene = SCNScene(named: "art.scnassets/ardiya.scn")
       let restaurantArdiyaNode = restaurantArdiyaScene?.rootNode.childNode(withName: "ardiya", recursively: false)
        if (projectName == restaurantArdiyaNode?.name){
            projectARName.isHidden = true
            restaurantArdiyaNode?.position = SCNVector3(0,-1,-8)
            self.centerPivot(for: restaurantArdiyaNode!)
            self.sceneView.scene.rootNode.addChildNode(restaurantArdiyaNode!)
        } else {
           projectARName.text = "خطأ في اسم المشروع"
        }
    }
    
  
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
       // To resize the object
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        // To rotate after long press
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
       
        longPressGestureRecognizer.minimumPressDuration = 0.1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinate = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinate)
        if hitTest.isEmpty {
            print("didn't touch any thing")
        } else {
          // let results = hitTest.first!
           // let node = results.node
            self.addNode()
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        // To get the location of pinch
        let pinchLocation = sender.location(in: sceneView)
        // HitTest to check match between the pinchLocation and obj location
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            let result = hitTest.first!
            //The node we pinch
            let node = result.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            node.runAction(pinchAction)
            sender.scale = 1.0
            
        }
        
    }
    
    @objc func rotate(sender: UILongPressGestureRecognizer) {
       let sceneView = sender.view as! ARSCNView
       let holdLocation = sender.location(in: sceneView)
       let hitTest = sceneView.hitTest(holdLocation)
        if !hitTest.isEmpty {
            let result = hitTest.first!
          
            if sender.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreeToRadius), z: 0, duration: 1)
               let forever = SCNAction.repeatForever(rotation)
                result.node.runAction(forever)
            } else if sender.state == .ended {
                result.node.removeAllActions()
            }
        }
        
    }
    
    func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
   
}

extension Int {
    var degreeToRadius: Double { return Double(self) * .pi/180 }
}


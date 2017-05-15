//
//  CameraViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var leftIndicator: UILabel!
    @IBOutlet weak var rightIndicator: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var dismissButton: UIButton!
    
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var locationManger = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    var selectedEvent: Event?
    
    var itemDesc: String?
    var eventLocation = CLLocation()

    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.isHidden = true
        
        loadCamera()
        self.cameraSession?.startRunning()
        self.locationManger.delegate = self
        self.locationManger.startUpdatingHeading()
        
        //TODO: setting local location get it from previous VC
        if let location = selectedEvent?.location {
            eventLocation = location
            debugPrint("Event location: \(eventLocation)")
        } else {
            debugPrint("Could not get location from event")
        }
        userLocation = self.locationManger.location!
        debugPrint(userLocation)
        
        sceneView.scene = scene
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        if let event = selectedEvent {
            if let trophy = event.trophy {
                if let itemDesc = trophy.itemDescription {
                    
                    self.itemDesc = itemDesc
                } else {
                    debugPrint("Description error")
                }
            } else {
                debugPrint("Trophy error")
            }
        }
        else {
            debugPrint("Event error")
        }
        
        setupTarget()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
        var error: NSError?
        var captureSession: AVCaptureSession?
        
        let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        if backVideoDevice != nil {
            var videoInput: AVCaptureDeviceInput!
            do {
                videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
            } catch let error1 as NSError {
                error = error1
                videoInput = nil
            }
            
            if error == nil {
                captureSession = AVCaptureSession()
                
                if captureSession!.canAddInput(videoInput) {
                    captureSession!.addInput(videoInput)
                } else {
                    error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
                }
            } else {
                error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
            }
        } else {
            error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
        }
        
        return (session: captureSession, error: error)
    }
    
    func loadCamera() {
        let captureSessionResult = createCaptureSession()
        
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
            debugPrint("Error creating capture session")
            return
        }
        
        self.cameraSession = session
        
        if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
            cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            cameraLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(cameraLayer, at: 0)
            self.cameraLayer = cameraLayer
        }
    }
    
    func repositionTarget() {
        let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: eventLocation)

        
        let delta = heading - self.heading
        
        if delta < -15.0 {
            leftIndicator.isHidden = false
            rightIndicator.isHidden = true
        } else if delta > 15 {
            leftIndicator.isHidden = true
            rightIndicator.isHidden = false
        } else {
            leftIndicator.isHidden = true
            rightIndicator.isHidden = true
        }
        
        let distance = userLocation.distance(from: eventLocation)
        
        if let node = selectedEvent?.trophy?.itemNode {
            if node.parent == nil {
                node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
                scene.rootNode.addChildNode(node)
            } else {
                node.removeAllActions()
                node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
            }
        }
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return (radians) * (180.0 / .pi)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return (degrees) * (.pi / 180.0)
    }
    
    func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
        let fLat = degreesToRadians(from.coordinate.latitude)
        let fLng = degreesToRadians(from.coordinate.longitude)
        let tLat = degreesToRadians(to.coordinate.latitude)
        let tLng = degreesToRadians(to.coordinate.longitude)
        
        let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
        if degree >= 0 {
            return degree
        } else {
            return degree + 360
        }
    }
    
    func setupTarget() {
        let scene = SCNScene(named: "art.scnassets/\(itemDesc!).scn")
        let enemy = scene?.rootNode.childNode(withName: self.itemDesc!, recursively: true)
        
        if self.itemDesc == "dragon" {
            enemy?.position = SCNVector3(x: 0, y: -10, z: -40)
//            enemy?.pivot = SCNMatrix4MakeTranslation(0, 1, 0)
            enemy?.pivot = SCNMatrix4MakeRotation(146, 0, 1, 0)
        } else if self.itemDesc == "wolf" {
            enemy?.position = SCNVector3(x: 0, y: 0, z: -18)
            enemy?.pivot = SCNMatrix4MakeRotation(165, 1, 2, 0)
        } else if self.itemDesc == "wrench"{
            enemy?.position = SCNVector3(x: 0, y: -5, z: 15)
            enemy?.pivot = SCNMatrix4MakeRotation(125, 94, 20, 0)
        } else if self.itemDesc == "m-dae"{
            enemy?.position = SCNVector3(x: 0, y: 0, z: 15)
            enemy?.pivot = SCNMatrix4MakeRotation(0, 0, 20, 0)

        }else {
            enemy?.position = SCNVector3(x: 0, y: 0, z: 0)
        }
        
        
        let node = SCNNode()
        node.addChildNode(enemy!)
        node.name = "enemy"
        self.selectedEvent?.trophy?.itemNode = node
       
//        createCustomTrophy()

    }
    
    func createCustomTrophy() {

        let scene = SCNScene()

        //Camera Node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 15, 30)
        cameraNode.pivot = SCNMatrix4MakeRotation(Float(-Double.pi/7.0), 1, 0, 0);
        scene.rootNode.addChildNode(cameraNode)

        //A SpotLight
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.color = UIColor.red
        let spotLightNode = SCNNode()
        spotLightNode.light = spotLight
        spotLightNode.position = SCNVector3Make(-2, 1, 0)
        cameraNode.addChildNode(spotLightNode)
        
        //Materials
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        
        //create box
        let boxSide: CGFloat = 5.0;
        let box = SCNBox(width: CGFloat(boxSide), height: CGFloat(boxSide), length: CGFloat(boxSide), chamferRadius: 0)
        box.materials = [redMaterial]
        
        let boxNode = SCNNode(geometry: box)
        boxNode.pivot = SCNMatrix4MakeRotation(.pi/3, 0, 1, 0)
        
        //color box 
        let spotColor = CAKeyframeAnimation(keyPath: "color")
        spotColor.values = [UIColor.red, UIColor.blue, UIColor.green, UIColor.red]
        spotColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        spotColor.repeatCount = Float.infinity
        spotColor.duration = 3.0
        
        spotLight.addAnimation(spotColor, forKey: "ChangeTheColorOfTheSpot")
        
        // Rotating the box
        let boxRotation = CABasicAnimation(keyPath: "transform")
//        boxRotation.toValue = NSValue(caTransform3D:CATransform3DRotate(boxNode.transform, Double.pi, 1, 1, 0))
        boxRotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        boxRotation.repeatCount = Float.infinity
        boxRotation.duration = 2.0
        spotLight.addAnimation(boxRotation, forKey: "RotateTheBox")
        
        scene.rootNode.addChildNode(boxNode)
        boxNode.name = "enemy"
        self.selectedEvent?.trophy?.itemNode = boxNode
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1
     
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResult = sceneView.hitTest(location, options: nil)
        
        if hitResult.first != nil {
            debugPrint("trophyTapped")
                        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let navVc = storyboard.instantiateViewController(withIdentifier: "TrophyUnlockedNavigationController") as? UINavigationController {
                if let viewController = navVc.topViewController as? TrophyUnlockedViewController {
                    if let event = self.selectedEvent {
                        viewController.completedEvent = event
                        if let trophy = event.trophy {
                            viewController.trophy = trophy
                            debugPrint("Description: \(String(describing: trophy.itemDescription))")

                            dismissButton.isHidden = true

                            self.present(navVc, animated: true, completion: nil)
                        }
                    }
                }
            }
                        
        }
        else {
            debugPrint("trophy Not Tapped")

        }
    }
    
    //Show Dismiss button when double tapped on the screen
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        debugPrint("Double Tapped")
        dismissButton.isHidden = false

    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismissButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = fmod(newHeading.trueHeading, 360.0)
        repositionTarget()
    }
}

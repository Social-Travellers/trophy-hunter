//
//  CreateTrophyViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/24/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import CoreLocation
import MapKit
import Parse

protocol HandleLocationSelect {
    func didSelectLocation(selectedPlacemark: MKPlacemark)
}

class CreateTrophyViewController: MenuItemContentViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createTrophyNavigationBar: UINavigationBar!
    @IBOutlet weak var createTrophyNavigationItem: UINavigationItem!

    @IBOutlet weak var trophyImageView: UIImageView!
    @IBOutlet weak var trophyEditImageView: UIImageView!
    @IBOutlet weak var trophyNameTextField: UITextField!
    @IBOutlet weak var trophyExpTextField: UITextField!
    @IBOutlet weak var trophyEventMapView: MKMapView!
    @IBOutlet weak var trophyEventSelectedLabel: UILabel!
    @IBOutlet weak var trophyEventNameTextField: UITextField!
    @IBOutlet weak var trophyLevelTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var trophyNamePickerView: UIPickerView!
    
    let locationManager = CLLocationManager()
    var mapCenterCoordinate: CLLocationCoordinate2D? = nil
    
    let trophyImagePicker = UIImagePickerController()
    
    var trophyNames: [String] = ["Car", "RaceCar", "Car2", "Computer History Museum", "Intuit", "Google", "Apple", "Arcanine", "Spider", "Wrench", "Dragon", "Wolf"]
    
    var trophyModelNames: [String] = ["car", "rc_car", "m-dae", "chm", "intuit", "google", "apple", "arcanine", "spider", "wrench", "dragon", "wolf"]
    
    // Trophy attributes
    var selectedTrophyName: String = ""
    var selectedTrophyModelName: String = ""
    var trophyPictureFile: PFFile? = nil
    var expPoints: NSNumber = 0
    
    // Event attributes
    var eventLevel: NSNumber = 0
    var eventLocation: PFGeoPoint? = nil
    var eventName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        trophyImageView.layer.cornerRadius = 3.0
        trophyImageView.clipsToBounds = true
        trophyEditImageView.layer.cornerRadius = 3.0
        trophyEditImageView.clipsToBounds = true
        
        trophyEventMapView.delegate = self
        trophyEventMapView.showsUserLocation = true
        startStandardUpdates()
        
        trophyNamePickerView = UIPickerView()
        trophyNamePickerView.delegate = self
        trophyNamePickerView.dataSource = self
        
        trophyNameTextField.delegate = self
        trophyNameTextField.inputView = trophyNamePickerView

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height/6, width: view.frame.size.width, height: 40.0))
        toolbar.layer.position = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 20.0)
        toolbar.barStyle = .default
        toolbar.tintColor = Constants.Color.THEMECOLOR
        toolbar.backgroundColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(trophyNameDoneButtonClicked))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        trophyNameTextField.inputAccessoryView = toolbar
        
        trophyImagePicker.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar() {
        createTrophyNavigationBar.barTintColor = Constants.Color.THEMECOLOR
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "Create Your Own Trophy"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        createTrophyNavigationItem.titleView = titleLabel
    }
    
    @IBAction func tappedInContainerView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func trophyImageViewTapped(_ sender: UITapGestureRecognizer) {
        trophyImagePicker.allowsEditing = false
        trophyImagePicker.sourceType = .photoLibrary
        trophyImagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(trophyImagePicker, animated: true, completion: nil)
    }
    
    func trophyNameDoneButtonClicked() {
        trophyNameTextField.text = selectedTrophyName
        view.endEditing(true)
    }
    
    @IBAction func trophyEventMapViewTapped(_ sender: UITapGestureRecognizer) {
        let locationSearchController = storyboard!.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
        locationSearchController.locationSelectDelegate = self
        
        present(locationSearchController, animated: true, completion: nil)
    }
    
    // MARK: - Event and Trophy creation
    
    @IBAction func createTrophyClicked(_ sender: UIButton) {
        createTrophyAndAssignToEvent()
    }
    
    func createTrophyAndAssignToEvent() {
        activityIndicatorView.startAnimating()
        
        // Trophy
        guard let image = trophyImageView.image else {
            print("No image selected for trophy")
            return
        }
        guard let trophyImageData = UIImageJPEGRepresentation(image, 0.0) else {
            print("No image data for trophy image")
            return
        }
        let trophyImageFile = PFFile(name: "image.png", data: trophyImageData)
        
        let expString = trophyExpTextField.text
        let expInt = Int(expString!)
        expPoints = NSNumber(integerLiteral: expInt!)
        
        let trophy = PFObject(className: "Trophy")
        trophy["name"] = selectedTrophyName
        trophy["picture"] = trophyImageFile
        trophy["experiencePoints"] = expPoints
        trophy["itemDescription"] = selectedTrophyModelName
        
        // Event
        guard let coordinate = mapCenterCoordinate else {
            print("No location selected")
            return
        }
        let selectedGeoPoint = PFGeoPoint(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude))
        
        eventName = trophyEventNameTextField.text!
        
        let levelString = trophyLevelTextField.text
        let levelInt = Int(levelString!)
        eventLevel = NSNumber(integerLiteral: levelInt!)
        
        let event = PFObject(className: "Event1")
        event["level"] = eventLevel
        event["location"] = selectedGeoPoint
        event["name"] = eventName
//        let trophyRelation = event["trophy"] as! PFRelation
//        trophyRelation.add(trophy)
        
        // Save Trophy and Event
        event.saveInBackground() { [unowned self] (succeeded: Bool, error: Error?) in
            if let error = error {
                print("Event save error: \(error.localizedDescription)")
            } else {
                print("Event and Trophy successfully saved")
                
                // Get saved event and connect trophy
                let query = PFQuery(className: "Event1")
                query.whereKey("location", equalTo: selectedGeoPoint)
                
                query.findObjectsInBackground(block: { (objects: [PFObject]?, queryError: Error?) in
                    if let queryError = queryError {
                        print("Query error: \(queryError.localizedDescription)")
                    } else {
                        if let queryObjects = objects {
                            if let eventObject = queryObjects.first {
                                let trophyRelation = eventObject.relation(forKey: "trophy")
                                trophyRelation.add(trophy)
                                
                                eventObject.saveInBackground() { (succeeded: Bool, saveError: Error?) in
                                    if let saveError = saveError {
                                        print("Event-Trophy relation save error: \(saveError.localizedDescription)")
                                    } else {
                                        // Stop activity indicator
                                        self.activityIndicatorView.stopAnimating()
                                        
                                        print("Successfully added trophy to event")
                                        
                                        let alertController = UIAlertController(title: "Success", message: "Trophy successfully created", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                        } else {
                            print("No objects found")
                        }
                    }
                })
                
            }
        }
    }
    
    // MARK: - Scroll view adjustments when keyboard is shown/hidden
    
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: Notification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateTrophyViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func setMapRegion(mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
        mapCenterCoordinate = coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            setMapRegion(mapView: trophyEventMapView, coordinate: location.coordinate)
            let locationString = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
            trophyEventSelectedLabel.text = locationString
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}

extension CreateTrophyViewController: HandleLocationSelect {
    
    func didSelectLocation(selectedPlacemark: MKPlacemark) {
        // clear previous annotations
        trophyEventMapView.removeAnnotations(trophyEventMapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedPlacemark.coordinate
        trophyEventMapView.addAnnotation(annotation)
        
        var name = selectedPlacemark.name
        if let city = selectedPlacemark.locality, let state = selectedPlacemark.administrativeArea {
            name?.append(" \(city), \(state)")
        }
        trophyEventSelectedLabel.text = name
        setMapRegion(mapView: trophyEventMapView, coordinate: selectedPlacemark.coordinate)
    }
    
}

extension CreateTrophyViewController: UITextFieldDelegate {
    
    func printTextFieldValues() {
        print("Trophy name: \(trophyNameTextField.text!)")
        print("Trophy exp: \(trophyExpTextField.text!)")
        print("Event name: \(trophyEventNameTextField.text!)")
        print("Event level: \(trophyLevelTextField.text!)")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == trophyNameTextField {
            textField.tintColor = UIColor.clear
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        printTextFieldValues()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
}

extension CreateTrophyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return trophyNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let trophyName = trophyNames[row]
        return trophyName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let trophyName = trophyNames[row]
        let trophyModelName = trophyModelNames[row]
        selectedTrophyName = trophyName
        selectedTrophyModelName = trophyModelName
    }
    
}

extension CreateTrophyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        trophyImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

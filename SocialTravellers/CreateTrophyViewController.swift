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

class CreateTrophyViewController: MenuItemContentViewController {
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
    var trophyNamePickerView: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    let trophyImagePicker = UIImagePickerController()
    
    var trophyNames: [String] = ["Car", "RaceCar", "Car2", "Computer History Museum", "Intuit", "Google", "Apple", "Arcanine", "Spider", "Wrench", "Dragon", "Wolf"]
    
    var trophyModelNames: [String] = ["car", "rc_car", "m-dae", "chm", "intuit", "google", "apple", "arcanine", "spider", "wrench", "dragon", "wolf"]
    
    var selectedTrophyName: String = ""
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        view.endEditing(true)
    }
    
    @IBAction func trophyEventMapViewTapped(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func createTrophyClicked(_ sender: UIButton) {
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
        locationManager.startUpdatingLocation()
    }
    
}

extension CreateTrophyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == trophyNameTextField {
            textField.tintColor = UIColor.clear
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == trophyNameTextField {
            textField.text = selectedTrophyName
        }
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
        selectedTrophyName = trophyName
        
        return trophyName
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

//
//  NewHintViewController.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import UIKit
import ImagePicker
import MapKit
import CoreLocation
import Sync


class NewHintViewController: UIViewController {
    var dataStack = DataStack()
    let imagePickerController = ImagePickerController()
    let coreLocationManager = CLLocationManager()
    @IBOutlet weak var hintTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    let span = MKCoordinateSpanMake(0.1, 0.1)
    @IBOutlet weak var pickedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hintTextField.delegate = self
        setUpImagePickerController()
        setUpLocationServices()
    }
    

    @IBAction func selectPhotoPressed(_ sender: Any) {
        tabBarController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoPressed(_ sender: UIButton) {
        let cameraVC = Router.shared.cameraVC as! CameraViewController
        cameraVC.delegate = self
        Router.shared.present(from: self, to: cameraVC)
    }
    
    @IBAction func postHintPressed(_ sender: UIButton) {
        self.dataStack = DataStack(modelName: "Challenge")
        //provide logic to remove need to force unwrap
        let currentHint = Challenge(photo: (pickedImageView.image?.accessibilityIdentifier!)!, hint: hintTextField.text!, latitude: NewHintLocationManager.shared.latitude!, longitude: NewHintLocationManager.shared.longitude!)
        let json = DataManager.shared.createJSONObject(from: currentHint)
//        dataStack.sync(json, inEntityNamed: "Challenge") { error in
//
//        }
    }
}

//MARK: - Image Picker
extension NewHintViewController: ImagePickerDelegate {
    func setUpImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //required func, not implemented
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let selectedImage = images.first {
            pickedImageView.image = selectedImage
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Hide Keyboard
extension NewHintViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hintTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Core Location Components
extension NewHintViewController: CLLocationManagerDelegate  {
    
    func setUpLocationServices() {
        coreLocationManager.delegate = self
        coreLocationManager.requestLocation()
    }
    
    func setRegionOnMap(_ location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
    }
    
    func setAnnotationOnMap(_ location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationFromDevice = locations.last else {return}
        let location = CLLocationCoordinate2DMake(locationFromDevice.coordinate.latitude, locationFromDevice.coordinate.longitude)
        NewHintLocationManager.shared.latitude = location.latitude
        NewHintLocationManager.shared.longitude = location.longitude
        setRegionOnMap(location)
        setAnnotationOnMap(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - Camera Delegate
extension NewHintViewController: CameraDelegate {
    func photoTaken(photo: UIImage) {
        print("called")
    }
    
    
}



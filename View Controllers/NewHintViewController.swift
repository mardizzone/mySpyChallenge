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


class NewHintViewController: UIViewController {
    
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
}


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
        setRegionOnMap(location)
        setAnnotationOnMap(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension NewHintViewController: CameraDelegate {
    func photoTaken(photo: UIImage) {
        print("called")
    }
    
    
}



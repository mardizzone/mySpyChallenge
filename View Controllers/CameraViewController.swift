//
//  CameraViewController.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var delegate: CameraDelegate?
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: "video")
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            captureSession = AVCaptureSession()
//            captureSession?.addInput(input)
//        } catch {
//            print(error)
//        }
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//        //videoPreviewLayer?.videoGravity = AVLayerVideoGravity
//        videoPreviewLayer?.frame = view.layer.bounds
//        previewView.layer.addSublayer(videoPreviewLayer!)
//        captureSession?.startRunning()
//        
//        capturePhotoOutput = AVCapturePhotoOutput()
//        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
//        captureSession?.addOutput(capturePhotoOutput!)
//        
//        
//    }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        // Make sure we get some photo sample buffer
//        guard error == nil,
//            let photoSampleBuffer = photoSampleBuffer else {
//                print("Error capturing photo: \(String(describing: error))")
//                return
//        }
//        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
//        guard let imageData =
//            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
//                return
//        }
//        // Initialise a UIImage with our image data
//        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
//        
//        if let image = capturedImage {
//            // Save our captured image to photos album
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
//    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

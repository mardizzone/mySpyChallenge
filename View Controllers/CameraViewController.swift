//
//  CameraViewController.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    

    @IBOutlet weak var navBar: UINavigationBar!
    var delegate: CameraDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

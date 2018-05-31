//
//  Router.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    static let shared = Router()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var cameraVC = {self.storyboard.instantiateViewController(withIdentifier: "camera")}()
    lazy var newHintVC = {self.storyboard.instantiateViewController(withIdentifier: "newHint")}()
    lazy var tabBarVC = {self.storyboard.instantiateViewController(withIdentifier: "tabBar")}()
    
    func present(from viewcontroller: UIViewController, to destinationViewController: UIViewController) {
        viewcontroller.tabBarController?.present(destinationViewController, animated: true, completion: nil)
    }
    
    
    
}

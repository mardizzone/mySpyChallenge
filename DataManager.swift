//
//  DataManager.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    static let shared = DataManager()

    func getData(from resourceName: String, with type: String) -> Data? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: type) else {return nil}
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            return data
        } catch {
            
        }
        return nil
    }
    
    func localImage(from file: String) -> UIImage? {
        guard let imageToReturn = UIImage(named: file) else {return nil}
        return imageToReturn
    }
    
    func createJSONObject(from challenge: Challenge) -> Data? {
        let encodedData = try? JSONEncoder().encode(challenge)
        return encodedData
    }
    
//    func sortChallengesBasedOnDistance(presorted: [Challenge]) -> [Challenge] {
//    }
}

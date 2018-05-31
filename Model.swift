//
//  Model.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import Foundation

struct JSONData : Codable {
    
    let challenges : [Challenge]
    
    static func decodeJSON(from data: Data) -> [Challenge]? {
        do {
            let response = try JSONDecoder().decode(JSONData.self, from: data)
            let challenges = response.challenges
            return challenges
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

struct Challenge : Codable {
    let photo : String
    let hint : String
    let latitude : Double
    let longitude : Double
}

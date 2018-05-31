//
//  ChallengesNearMeViewController.swift
//  iSpyChallenge
//
//  Created by Michael Ardizzone on 5/31/18.
//  Copyright © 2018 Blue Owl. All rights reserved.
//

import UIKit

class ChallengesNearMeViewController: UIViewController {
    
    var challengesForTableView = [Challenge]()
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIntoTableView()
    }

    func loadDataIntoTableView() {
        guard let dataFromLocalJSON = DataManager.shared.getData(from: "challenges", with: "json") else {return}
        if let challenges = JSONData.decodeJSON(from: dataFromLocalJSON) {
            challengesForTableView = challenges
            challengesTableView.reloadData()
        }
    }
}

extension ChallengesNearMeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = challengesTableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        let particularChallenge = challengesForTableView[indexPath.row]
        cell.hintLabel.text = particularChallenge.hint
        cell.locationLabel.text = "latitude: \(particularChallenge.latitude)   longitude: \(particularChallenge.longitude)"
        cell.hintImageView.image = DataManager.shared.localImage(from: particularChallenge.photo)
        return cell
    }
}

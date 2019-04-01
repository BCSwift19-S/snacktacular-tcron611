//
//  ViewController.swift
//  Snacktacular
//
//  Created by John Gallaugher on 3/23/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import CoreLocation

class SpotsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var spots: Spots!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spots = Spots()
        spots.spotsArray.append(Spot(name: "El Pelon", address: "Comm. Ave", coordinate: <#T##CLLocationCoordinate2D#>, averageRating: <#T##Double#>, numberOfReviews: <#T##Int#>, postingUserID: <#T##String#>, documentID: <#T##String#>))
    }
}


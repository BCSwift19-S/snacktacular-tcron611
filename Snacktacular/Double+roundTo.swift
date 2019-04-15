//
//  Double+roundTo.swift
//  Snacktacular
//
//  Created by Thomas Ronan on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double((places >= 0 ? places : 0)))
        let rounded = (self * tenToPower).rounded() / tenToPower
        return rounded
    }
}

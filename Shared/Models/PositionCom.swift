//
//  PositionCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-28.
//

import Foundation
import RealityKit

class PositionCom: Component {
    var altitude: Int32
    var geohash: String
    
    init(altitude: Int32, geohash: String) {
        self.altitude = altitude
        self.geohash = geohash
    }
}

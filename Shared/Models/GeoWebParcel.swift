//
//  GeoWebParcel.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-12-18.
//

import Foundation
import SwiftData
import CoreLocation
import SwiftMUD
import Turf

@Model
final class GeoWebParcel {
    @Attribute(.unique) var id: String
    var coordinates: [CLLocationDegrees]?
    var bboxE: CLLocationDegrees?
    var bboxW: CLLocationDegrees?
    var bboxN: CLLocationDegrees?
    var bboxS: CLLocationDegrees?
    var tokenURI: String?
    
    var distanceAway: CLLocationDistance?
    
    @Transient
    var clCoordinates: [CLLocationCoordinate2D]? {
        guard let bboxN = bboxN, let bboxS = bboxS, let bboxE = bboxE, let bboxW = bboxW  else { return nil }

        return [
            CLLocationCoordinate2D(latitude: bboxN, longitude: bboxW),
            CLLocationCoordinate2D(latitude: bboxN, longitude: bboxE),
            CLLocationCoordinate2D(latitude: bboxS, longitude: bboxE),
            CLLocationCoordinate2D(latitude: bboxS, longitude: bboxW)
        ]
    }
    
    @Transient
    var polygon: Polygon? {
        guard let bboxN = bboxN, let bboxS = bboxS, let bboxE = bboxE, let bboxW = bboxW  else { return nil }

        return Polygon([[
            LocationCoordinate2D(latitude: bboxS, longitude: bboxW),
            LocationCoordinate2D(latitude: bboxN, longitude: bboxW),
            LocationCoordinate2D(latitude: bboxN, longitude: bboxE),
            LocationCoordinate2D(latitude: bboxS, longitude: bboxE),
        ]])
    }
    
    @Transient
    var lineE: LineString? {
        guard let bboxN = bboxN, let bboxS = bboxS, let bboxW = bboxW  else { return nil }

        return LineString([
            LocationCoordinate2D(latitude: bboxS, longitude: bboxW),
            LocationCoordinate2D(latitude: bboxN, longitude: bboxW)
        ])
    }
    @Transient
    var lineW: LineString? {
        guard let bboxN = bboxN, let bboxS = bboxS, let bboxE = bboxE else { return nil }

        return LineString([
            LocationCoordinate2D(latitude: bboxS, longitude: bboxE),
            LocationCoordinate2D(latitude: bboxN, longitude: bboxE)
        ])
    }
    @Transient
    var lineN: LineString? {
        guard let bboxN = bboxN, let bboxE = bboxE, let bboxW = bboxW  else { return nil }

        return LineString([
            LocationCoordinate2D(latitude: bboxN, longitude: bboxE),
            LocationCoordinate2D(latitude: bboxN, longitude: bboxW)
        ])
    }
    @Transient
    var lineS: LineString? {
        guard let bboxS = bboxS, let bboxE = bboxE, let bboxW = bboxW  else { return nil }

        return LineString([
            LocationCoordinate2D(latitude: bboxS, longitude: bboxE),
            LocationCoordinate2D(latitude: bboxS, longitude: bboxW)
        ])
    }
    
    init(id: String, coordinates: [CLLocationDegrees]? = nil, bboxE: CLLocationDegrees? = nil, bboxW: CLLocationDegrees? = nil, bboxN: CLLocationDegrees? = nil, bboxS: CLLocationDegrees? = nil, tokenURI: String? = nil) {
        self.id = id
        self.coordinates = coordinates
        self.bboxE = bboxE
        self.bboxW = bboxW
        self.bboxN = bboxN
        self.bboxS = bboxS
        self.tokenURI = tokenURI
    }
}

extension StoreActor {
    func updateParcels(currentUserLocation: CLLocationCoordinate2D, parcels: [GeoWebParcel]) throws {
        for parcel in parcels {
            let id = parcel.id
            let latestValue = FetchDescriptor<GeoWebParcel>(
                predicate: #Predicate { $0.id == id }
            )
            let results = try modelContext.fetch(latestValue)
             
            if let polygon = parcel.polygon {
                if polygon.contains(currentUserLocation) {
                    parcel.distanceAway = 0
                } else if
                    let distanceN = parcel.lineN?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                    let distanceS = parcel.lineS?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                    let distanceE = parcel.lineE?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                    let distanceW = parcel.lineW?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation)
                {
                    parcel.distanceAway = min(min(min(distanceN, distanceS), distanceE), distanceW)
                }
            } else {
                parcel.distanceAway = nil
            }

            
            if let existingRecord = results.first {
                existingRecord.bboxE = parcel.bboxE
                existingRecord.bboxS = parcel.bboxS
                existingRecord.bboxW = parcel.bboxW
                existingRecord.bboxN = parcel.bboxN
                existingRecord.coordinates = parcel.coordinates
                existingRecord.tokenURI = parcel.tokenURI
                existingRecord.distanceAway = parcel.distanceAway
            } else {
                modelContext.insert(parcel)
            }
        }
        
        try modelContext.save()
    }
    
    func updateParcelsDistanceAway(currentUserLocation: CLLocationCoordinate2D) throws {
        let parcels = try modelContext.fetch(FetchDescriptor<GeoWebParcel>())
        for parcel in parcels {
            guard let polygon = parcel.polygon else {
                parcel.distanceAway = nil
                return
            }
            
            if polygon.contains(currentUserLocation) {
                parcel.distanceAway = 0
            } else if
                let distanceN = parcel.lineN?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                let distanceS = parcel.lineS?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                let distanceE = parcel.lineE?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation),
                let distanceW = parcel.lineW?.closestCoordinate(to: currentUserLocation)?.coordinate.distance(to: currentUserLocation)
            {
                parcel.distanceAway = min(min(min(distanceN, distanceS), distanceE), distanceW)
            }
        }
        
        try modelContext.save()
    }
}

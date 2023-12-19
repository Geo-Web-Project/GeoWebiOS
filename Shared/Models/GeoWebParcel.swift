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
    var locationCenter: CLLocation? {
        guard let bboxN = bboxN, let bboxS = bboxS, let bboxE = bboxE, let bboxW = bboxW  else { return nil }
        
        let deltaLon = abs(bboxW - bboxE)
        let deltaLat = abs(bboxN - bboxS)
        return CLLocation(
            latitude: bboxS + deltaLat,
            longitude: bboxW + deltaLon
        )
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
             
            if let center = parcel.locationCenter {
                parcel.distanceAway = CLLocation(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude).distance(from: center)
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
            if let center = parcel.locationCenter {
                parcel.distanceAway = CLLocation(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude).distance(from: center)
            } else {
                parcel.distanceAway = nil
            }
        }
        
        try modelContext.save()
    }
}

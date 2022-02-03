//
//  BusStops.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/13.
//

import Foundation
import FirebaseFirestore
import MapKit

// MARK: StopPinPoint
final class Stops: MKPointAnnotation, Codable, Identifiable {
    
    var id: String?
    var name: BusStopName
    var images: [String]?
    var landMarks: [String]?
//    var coordinate: CLLocationCoordinate2D
    var prevNexStop: [String]?
    var pole: String?
    init(id: String?, name: BusStopName, images: [String]?, landMarks: [String]?, prevNextStop: [String]?, pole: String?) {
        self.id = id
        self.name = name
//        self.coordinate = coordinates
        self.images = images
        self.landMarks = landMarks
        self.prevNexStop = prevNextStop
        self.pole = pole
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

extension Array where Element == Stops {
    mutating func sort(by location: CLLocation) {
        return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
    
    func sorted(by location: CLLocation) -> [Stops] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}

// MARK: Bus Stop Names Collection:
/**
 * Struct of the bus stop's name
 * currently available in English and Japanese
 */
struct BusStopName: Codable {
    var english: String?
    var japanese: String?
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

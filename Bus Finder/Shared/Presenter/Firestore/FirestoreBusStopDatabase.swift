//
//  FirestoreBusStopDatabase.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/13.
//

import Foundation
import FirebaseFirestore
import MapKit


class BusStops: ObservableObject {
    @Published var stops = [Stops]()
    
    private var db = Firestore.firestore()
    
    init() {
        fetchAllStops()
    }
    
    func fetchAllStops() {

        db.collection("BusStops").getDocuments(source: .default) { (querySnapShots, error) in
            guard let documents = querySnapShots?.documents else {
                print("⚠️ No documents")
                return
            }
            
            self.stops = documents.map({ (queryDocumentSnapshot) -> Stops in
                let data   = queryDocumentSnapshot.data()
                let id     = queryDocumentSnapshot.documentID
                let names  = data["name"] as! [String: Any]
                print(names)
                let images = data["images"] as? [Any]
                let coordinates = data["coordinates"] as! GeoPoint
                let landMarks = data["landMarks"] as? [Any]
                let prevNextStop = data["prev_next_stops"] as? [Any]
                let pole_val = data["pole_val"] as Any
                let results = Stops(id: id,
                                    name: BusStopName(english: names["en"] as? String, japanese: names["jp"] as? String),
                                    images: images as? [String],
                                    landMarks: landMarks as? [String],
                                    prevNextStop: prevNextStop as? [String], pole: pole_val as? String)
                results.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                results.title = results.name.japanese
                results.subtitle = results.name.english
                
                return results
            })
            

        }
    }
}

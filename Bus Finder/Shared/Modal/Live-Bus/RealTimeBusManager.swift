//
//  RealTimeBusManager.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/07/21.
//

import Foundation
import Alamofire
import MapKit
import SwiftyJSON

struct BusLoaction : Identifiable{
    public var id: Int
    public var geo: CLLocationCoordinate2D
    public var line: String
    public var dest: String
    public var after_time: String
    public var expected_arrival: String
    public var delayed: Bool
}

class RealTimeBus : ObservableObject {
    
    @Published var buses = [BusLoaction]()
    
    
    
    func getBuses(pole busPole: String)
    {
        if busPole == "" {
            print("none")
            return }
        let finalURL = "https://bus.st0.me/ohmi/\(busPole)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(String(finalURL!)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var alldata = [BusLoaction]()
                for item in json["status"] {
                    print(item)
                    print(type(of: item))
                    var ires = BusLoaction(id: item["id"], geo: CLLocationCoordinate2D(latitude: item["geo"]["latitude"], longitude: item["geo"][""]), line: <#T##String#>, dest: <#T##String#>, after_time: <#T##String#>, expected_arrival: <#T##String#>, delayed: <#T##Bool#>)
                    alldata.append(<#T##newElement: BusLoaction##BusLoaction#>)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

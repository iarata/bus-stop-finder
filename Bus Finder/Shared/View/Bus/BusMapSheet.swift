//
//  BusMapSheet.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/27.
//

import SwiftUI
import MapKit
import BottomSheet

struct BusMapSheet: View {
    
    //  MARK: Variables
    @ObservedObject var busStops: BusStops
    @ObservedObject var locationVM: LocationViewModel
    
    @Binding var searchText: String

    @Binding var busIs: Stops
    
    @Binding var isDetailsActive: Bool
    @Binding var activeBus: Stops
    @Binding var bottomSheetPosition: BottomSheetPosition
    
    var body: some View {
        
        // MARK: Details Page
        if isDetailsActive {
            StopDetail(isActive: $isDetailsActive, busItem: $busIs, userlocation: CLLocation(latitude: locationVM.userLatitude, longitude: locationVM.userLongitude))
        } else {
                // MARK: Bus Stop Lists
                ScrollView {
                    ForEach(busStops.stops.sorted(by: CLLocation(latitude: locationVM.userLatitude, longitude: locationVM.userLongitude)).filter({ searchText.isEmpty ? true : ($0.name.japanese ?? "").contains(searchText) || ($0.name.english ?? "").contains(searchText) }), id: \.id) { item in
                        BusStopItem(bsiDetails: item, userLocation: CLLocation(latitude: locationVM.userLatitude, longitude: locationVM.userLongitude)).onTapGesture {
                            self.activeBus = item
                            self.isDetailsActive.toggle()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }

        }
        
        
        
    }
}

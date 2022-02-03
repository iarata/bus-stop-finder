//
//  BusStopItem.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/13.
//

import SwiftUI
import MapKit

struct BusStopItem: View {
    
    @State private var selectedLanguage = Bundle.main.preferredLocalizations.first
    @State var bsiDetails: Stops
    @State var userLocation: CLLocation
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(bsiDetails.name.japanese ?? "n/a").bold().foregroundColor(Color(UIColor.label))
                    Text(bsiDetails.name.english ?? "n/a").font(.footnote).foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", bsiDetails.distance(to: userLocation))).font(.footnote).italic()
                        Image(systemName: "circlebadge.fill").foregroundColor(.green)
                    }
                    Spacer()
                }
            }.padding()
        }
        .background(Color("itemsBackground")).cornerRadius(16).padding(.horizontal)
    }
}

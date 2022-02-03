//
//  StopDetails.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/07/14.
//

import SwiftUI
import MapKit

struct StopDetail: View {
    
    @Binding var isActive: Bool
    @Binding var busItem: Stops
    @State var userlocation: CLLocation
    
    @ObservedObject var busCLL = RealTimeBus()
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack{
                    Button(action: {
                        isActive.toggle()
                    }) {
                        Label("Back", systemImage: "chevron.left").padding([.horizontal, .bottom])
                    }
                    Spacer()
                }
                Spacer()
                
                List {
                    Section(header: HStack {
                                Label("Information", systemImage: "info.circle")
                                Spacer()
                                Image(systemName: "circlebadge.fill").foregroundColor(.green)
                    }) {
                        HStack {
                            Text("Name:").foregroundColor(Color(UIColor.systemGray3))
                            VStack(alignment: .leading) {
                                Text(busItem.name.japanese ?? "").bold()
                                Text(busItem.name.english ?? "").font(.footnote)
                            }
                        }
                        
                        HStack {
                            Text("Distance:").foregroundColor(Color(UIColor.systemGray3))
                            Text("\(String(format: "%.1f", busItem.distance(to: userlocation))) meter")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .edgesIgnoringSafeArea(.all)
                

            }
        }.onAppear {
            busCLL.getBuses(pole: busItem.pole ?? "")
//            UITableView.appearance().backgroundColor = .clear
        }
    }
}

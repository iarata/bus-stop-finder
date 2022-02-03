//
//  Map.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI
import Combine
import MapKit
import BottomSheet

struct BusMap: View {
    
    @State var showAsk = false
    
    //  MARK: Variables
    @ObservedObject var session = SessionStore()
    @ObservedObject var locationViewModel = LocationViewModel()
    @ObservedObject var busStopsList = BusStops()
    
    @State private var action: MapView.Action = .idle
    @State var region = MKCoordinateRegion.defaultRegion
    
    @State var isDetailsActive = false
    @State var activeBus: Stops = Stops(id: nil, name: BusStopName(english: nil, japanese: nil), images: nil, landMarks: nil, prevNextStop: nil, pole: nil)
    
    @State private var bottomSheetPosition: BottomSheetPosition = .middle
    @State private var settingSheet = false
    
    @State var searchText = ""
    @State var isEditing = false
    
    private func setCurrentLocation() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationViewModel.userLatitude, longitude: locationViewModel.userLongitude), latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    func getMKCoordinate(_ stop: Stops, isStop: Bool) {
        if isStop {
            region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stop.coordinate.latitude, longitude: stop.coordinate.longitude), latitudinalMeters: 500, longitudinalMeters: 500)
        } else {
            setCurrentLocation()
        }
    }
    
    var body: some View {
        ZStack {
            if locationViewModel.location != nil {
                
                // MARK: MapView
                MapView(stops: $busStopsList.stops, centerCoordinate: $region, action: $action, selectedStop: $activeBus, isDetailsActive: $isDetailsActive)
                    .onAppear {
                        setCurrentLocation()
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    // MARK: Bottom Sheet
                    .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, headerContent: {
                        VStack {
                            //A SearchBar as headerContent.
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField("Search", text: self.$searchText, onCommit: {
                                    self.bottomSheetPosition = .middle
                                })
                                .onTapGesture {
                                    self.isEditing.toggle()
                                }
                                Spacer()
                                if isEditing {
                                    Button(action: {
                                        self.searchText = ""
                                        self.isEditing = false
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                                
                            }
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.quaternaryLabel)))
                            .padding(.bottom)
                            .onTapGesture {
                                self.bottomSheetPosition = .middle
                            }
                            
                        }
                    }) {
                        
                        // MARK: Sheet Contents
                        BusMapSheet(busStops: busStopsList,
                                    locationVM: locationViewModel,
                                    searchText: $searchText,
                                    busIs: self.$activeBus,
                                    isDetailsActive: self.$isDetailsActive,
                                    activeBus: self.$activeBus,
                                    bottomSheetPosition: self.$bottomSheetPosition)
                        
                        
                        
                    }
                
                // MARK: Map Interaction Buttons
                VStack(spacing:0) {
                    HStack {
                        Spacer()
                        VStack(spacing:0) {
                            // MARK: User location
                            Button {
                                withAnimation {
                                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                                    impactMed.impactOccurred()
                                    setCurrentLocation()
                                    self.action = .reset(coordinate: region)
                                }
                            } label: {
                                Image(systemName: "paperplane.fill").font(.system(size: 17)).padding(14).foregroundColor(Color("secondary"))
                            }
                            
                            // MARK: Settings
                            Button {
                                
                                withAnimation {
                                    self.settingSheet.toggle()
                                }
                            } label: {
                                Image(systemName: "gearshape.fill").font(.system(size: 17)).padding(14).foregroundColor(Color("secondary"))
                            }
                        }.background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial)).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("secondary"), lineWidth: 3)).padding().padding(.vertical, 2)
                        
                    }
                    Spacer()
                }
            } else {
                HStack {
                    ProgressView().padding(.horizontal, 2)
                    Text("Locating user location...").onTapGesture {
                        session.signOut()
                    }
                }
            }
            
            
            
        }.onAppear {
            setCurrentLocation()
        }
        .sheet(isPresented: $settingSheet, content: {
            Settings(settingsSheet: $settingSheet)
        })
    }
}




struct AnyMapAnnotationProtocol: MapAnnotationProtocol {
    let _annotationData: _MapAnnotationData
    let value: Any
    
    init<WrappedType: MapAnnotationProtocol>(_ value: WrappedType) {
        self.value = value
        _annotationData = value._annotationData
    }
}

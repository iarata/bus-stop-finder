//
//  Home.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI
import Firebase
import MapKit

struct Home: View {
    
//  MARK: Variaables
    @ObservedObject var session = SessionStore()

    var body: some View {
        Group {
            if (session.session != nil) {
                BusMap()
            } else {
                Login().animation(.default)
            }
        }.onAppear() {
            session.listen()
            Auth.auth().useAppLanguage()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

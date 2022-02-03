//
//  Bus_FinderApp.swift
//  Shared
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI
import Firebase

@main
struct Bus_FinderApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}

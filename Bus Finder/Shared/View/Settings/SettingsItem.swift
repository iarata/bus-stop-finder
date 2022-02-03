//
//  ProfileView.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/12.
//

import SwiftUI

struct SettingsItem: View {
    
//  MARK: Variables
    @State var icon: String
    @State var text: String
    
    var body: some View {
        Label(LocalizedStringKey(text), systemImage: icon).font(.system(size: 18)).accentColor(Color.primary)
    }
}


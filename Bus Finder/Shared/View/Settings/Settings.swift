//
//  Settings.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/12.
//

import SwiftUI

struct Settings: View {
    //  MARK: Variables
    @Binding var settingsSheet: Bool
    @ObservedObject var session = SessionStore()
    @State private var selectedLanguage = Bundle.main.preferredLocalizations.first
    
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    
                    // account
                    NavigationLink(destination: Account()) {
                        SettingsItem(icon: "person.circle", text: "Account")
                    }
                    
                    // language
                    HStack {
                        SettingsItem(icon: "globe", text: "Language")
                        Spacer()
                        Text(getCurrentLanguage(str: selectedLanguage!)).foregroundColor(.gray)
                    }.onTapGesture {
                        withAnimation {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                    
                    // account
                    NavigationLink(destination: Text("s")) {
                        SettingsItem(icon: "heart.text.square", text: "Write a Review")
                    }
                    
                    
                }
                
                Section {
                    NavigationLink(destination: Profile()) {
                        SettingsItem(icon: "sparkles", text: "Suggest a feature")
                    }
                    
                    NavigationLink(destination: Text("s")) {
                        SettingsItem(icon: "exclamationmark.bubble", text: "Report a bug")
                    }
                    
                }
                
                // logout
                Section(footer:
                            HStack { Spacer()
                                VStack {
                                    HStack(spacing: 0) {
                                        Text("Made with ")
                                        Image(systemName: "heart.fill").foregroundColor(.red).font(.system(size: 12))
                                        Text(" in Japan")
//                                        Text("Japan").bold()
                                    }
                                    Text("Ritsumeikan University - ISSE 2020").bold()
                                }
                                Spacer() }.padding(.top, 10) ) {
                    
                    
                    Button(action: {
                        withAnimation {
                            session.signOut()
                        }
                    }) {
                        HStack {
                            Text("Log Out").bold().foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                
                
                
                
                
                
                
            }.listStyle(InsetGroupedListStyle())
            
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .secondarySystemBackground
        }
    }
}

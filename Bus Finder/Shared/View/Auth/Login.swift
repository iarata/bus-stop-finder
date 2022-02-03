//
//  Login.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI

struct Login: View {
    
    // MARK: - Variables
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    @State var errorMsg = ""
    @State var isEmailValid = true
    
    @StateObject var session = SessionStore()
    @Environment(\.colorScheme) var currentScheme

    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, e) in
            self.loading = false
            if e != nil {
                self.errorMsg = e?.localizedDescription ?? ""
                self.error = true
            } else {
                self.email = ""
                self.password = ""
                print(result?.user ?? "")
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack(alignment:.leading) {
                
                Spacer()
                
                Text("🚌").font(.system(size: 68)).padding(.top)
                (Text("Welcome to ")+Text("Bus Stop").foregroundColor(Color(hex: "FDD017"))+Text(" Finder").font(.custom("Times New Roman", size: 48))).font(.custom("Times New Roman", size: 48)).fontWeight(.black).padding(.bottom, 20)
                
                
                EmailField(icon: Image(systemName: "person.fill"), title: "Email", text: $email, isEmailValid: $isEmailValid)
                
                PasswordField(icon: Image(systemName: "lock.fill"), title: "Password", text: $password)
                
                
                
                Button {
                    print("forgot pwd")
                } label: {
                    HStack {
                        Spacer()
                        Text("Forgot password?").foregroundColor(Color(hex: "FDD017"))
                    }
                }
                
                
                Button(action: signIn) {
                    HStack {
                        Spacer()
                        Text("Sign in")
                            .padding()
                            .foregroundColor(Color("secondaryButtonLabel"))
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .padding(.vertical, 3)
                        Spacer()
                    }.background(Color("secondaryButtonBackground")).cornerRadius(16).padding(.top)
                }.alert(isPresented: $error) {
                    Alert(title: Text("Opps.."), message: Text(errorMsg), dismissButton: .default(Text("OK")))
                }
                
                
                HStack {
                    Spacer()
                    Text("Not a member?")
                    NavigationLink(destination: Register()) {
                        Text("Join Now").foregroundColor(Color(hex: "FDD017"))
                    }.padding(0)
                    Spacer()
                }
                Spacer()
                
                Group {
                    if self.currentScheme == .light {
                        AppleSignIn().frame(height: 55, alignment: .center).cornerRadius(16).signInWithAppleButtonStyle(.black)
                    } else {
                        AppleSignIn().frame(height: 55, alignment: .center).cornerRadius(16).signInWithAppleButtonStyle(.white)
                    }
                }
                    
                    .navigationBarHidden(true)
            }
            .padding()
        }
        
        
        
    }
    
    
}

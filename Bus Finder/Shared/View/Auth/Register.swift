//
//  Register.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI

struct Register: View {
    
    //  MARK: Variables
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    @State var loading = false
    @State var error = false
    @State var errorMsg = ""
    @State var isEmailValid = false
    
    @ObservedObject var session = SessionStore()
    
    func signUp () {
        loading = true
        error = false
        session.signUp(email: email, password: password) { (result, e) in
            if e != nil || password != passwordConfirm {
                print("\(String(describing: e))")
                if password != passwordConfirm {
                    self.errorMsg = "Passwords do not match"
                } else {
                    self.errorMsg = e!.localizedDescription
                }
                self.error = true
            } else {
                self.email = ""
                self.password = ""
                self.passwordConfirm = ""
                self.loading = false
                
            }
            print(result?.user ?? "")
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
                        
            Text("🧑‍💻").font(.system(size: 64)).padding(.top)
            Text("Create an Account").font(.custom("Times New Roman", size: 48)).fontWeight(.black).padding(.bottom, 20)
            
            
            HStack {
                Image(systemName: "person.fill").font(.system(size: 20)).foregroundColor(.gray).padding([.leading, .vertical])
                TextField("Email" ,text: $email)
                    .padding([.vertical, .trailing])
                    .padding(.leading, 5)
                    .font(Font.body.bold())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
            }.background(Color.gray.opacity(0.2)).cornerRadius(16)
           
            
            PasswordField(icon: Image(systemName: "lock.fill"), title: "Password", text: $password)
            PasswordField(icon: Image(systemName: "lock.fill"), title: "Password Confirmation", text: $passwordConfirm)
            if password != passwordConfirm && password != "" && passwordConfirm != "" {
                Text("Passwords does't match!").font(.footnote).foregroundColor(.red)
            }
            
            Button(action: signUp) {
                HStack {
                    Spacer()
                    Text("Register")
                        .padding()
                        .foregroundColor(Color("secondaryButtonLabel"))
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .padding(.vertical, 3)
                    Spacer()
                }.background(Color("secondaryButtonBackground")).cornerRadius(16).padding(.top)
            }
            .alert(isPresented: $error) {
                Alert(title: Text("Opps.."), message: Text(errorMsg), dismissButton: .default(Text("OK")))
            }
            Text("By pressing the register button you agree with our terms of service and privacy polices").font(.footnote)
            
            Spacer()
                
            
        }.padding()
    }
    
}

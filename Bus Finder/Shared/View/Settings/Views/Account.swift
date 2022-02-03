//
//  Account.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/29.
//

import SwiftUI

struct Account: View {
    
    @ObservedObject var session = SessionStore()
    @State private var user = SessionStore().getUser()
    @State var email = ""
    
    @State private var displayName = ""
    
    @State private var loading = false
    @State private var alert: BAlert?
    @State private var deleteConfirmation = false
    
    @State private var password = ""
    @State private var confirmPassword = ""

    @State var changed = false
    
    
    var body: some View {
        List {
            
            // MARK: Profile
            Section {
                HStack {
                    Image("profileDefault").resizable().clipShape(Circle()).frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        TextField("Name", text: $displayName)
                        Text(session.getUser().email ?? "Error").font(.system(size: 14)).foregroundColor(Color(UIColor.systemGray2))
                        Spacer()
                        
                    }
                }
            }
            
            // MARK: Security
            Section(header: Text("Security"), footer:
                        Group {
                            if self.password != self.confirmPassword {
                                Text("Passwords don't match!").foregroundColor(.red)
                            } else if session.getProvider()?[0] ?? "n/a" == "apple.com" {
                                Text("Passwords are disabled for apple provider.")
                            }
                        }) {
                TextField("Email", text: $email).disabled(session.getProvider()?[0] ?? "n/a" == "apple.com" ? true:false).foregroundColor(session.getProvider()?[0] ?? "n/a" == "apple.com" ? Color(UIColor.systemGray2) : Color.black).textContentType(.username)
                Group {
                    SecureField("Password", text: $password).textContentType(.oneTimeCode)
                    SecureField("Confirm Password", text: $confirmPassword).textContentType(.oneTimeCode)
                }
            }.disabled(session.getProvider()?[0] ?? "n/a" == "apple.com" ? true:false)
            
            
            // MARK: Account Deleting
            Section(footer: Text("Your account will be deleted immediately and we will not be able to restore your account in any case.")) {
                Button {
                    self.deleteConfirmation.toggle()
                } label: {
                    Text("Delete Account").foregroundColor(.red).bold()
                }
                .actionSheet(isPresented: $deleteConfirmation) {
                    ActionSheet(title: Text("Delete Account"), message: Text("Are you sure that you want to delete your account? This action is not reversible!"), buttons: [
                                    .destructive(Text("Delete"), action: {
                                        self.session.deleteAccount { error in
                                            if let error = error {
                                                self.alert = BAlert(.error, title: "An error occured", message: error.localizedDescription)
                                            }
                                        }
                                    }), .cancel()])
                }
                
            }
            
            
        }.listStyle(InsetGroupedListStyle())
        .alert(item: $alert, content: { (alert) in
            if alert.id != .custom {
                return Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("Close")))
            } else {
                return Alert(title: Text(alert.title), message: Text(alert.message), primaryButton: alert.primary!, secondaryButton: alert.secondary!)
            }
        })
        
        
        .navigationTitle("Account")
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                self.loading.toggle()
                if self.email != user.email {
                    session.updateEmail(to: email) { (error) in
                        if let error = error {
                            self.loading.toggle()
                            self.alert = BAlert.init(.error, title: "An error occured", message: error.localizedDescription)
                        } else {
                            self.loading.toggle()
                            self.alert = BAlert.init(.success, title: "Success", message: error?.localizedDescription ?? "Successfully updated!")
                        }
                    }
                }
                
                if self.displayName != session.getUser().displayName {
                    session.updateName(to: self.displayName) { (error) in
                        if let error = error {
                            self.loading.toggle()
                            self.alert = BAlert.init(.error, title: "An error occured", message: error.localizedDescription)
                        } else {
                            self.loading.toggle()
                            self.displayName = session.getUser().displayName ?? ""
                            self.alert = BAlert.init(.success, title: "Success", message: "Your name has been successfully updated.")
                        }
                    }
                }
            }
        }, label: {
            HStack {
                Text("Save").padding(.vertical)
            }
        }).disabled((self.password != "" || self.email != session.getUser().email ?? "n/a" || self.displayName != user.displayName) ? false : true)
        )
        .onAppear {
            self.displayName = user.displayName ?? ""
            self.email = user.email ?? ""
        }
    }
}

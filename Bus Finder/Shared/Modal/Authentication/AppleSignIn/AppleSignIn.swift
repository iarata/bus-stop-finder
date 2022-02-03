//
//  AppleSignIn.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/29.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices

struct AppleSignIn: View {
    
    @ObservedObject var session = SessionStore()
    @ObservedObject var appleLogin = AppleSignInModel()
    
    @State var loginErrorAlert = false
    @State var loginErrorAlertMsg = ""
    
    var body: some View {
        SignInWithAppleButton(.continue) { (request) in
            let nounce = appleLogin.randomNonceString()
            appleLogin.nonce = nounce
            request.requestedScopes = [.email, .fullName]
            request.nonce = appleLogin.sha256(nounce)
            
        } onCompletion: { (result) in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    
                    guard let nonce = appleLogin.nonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                    }
                    
                    //Creating a request for firebase
                    let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                    
                    session.credentialLogin(credential: credential) { (authResult, error) in
                        if (error != nil) {
                            // Error. If error.code == .MissingOrInvalidNonce, make sure
                            // you're sending the SHA256-hashed nonce as a hex string with
                            // your request to Apple.
                            self.loginErrorAlertMsg = error?.localizedDescription ?? "Unable to login. Please try again."
                            self.loginErrorAlert.toggle()
                            return
                        }
                    }
                default:
                    break
                    
                }
            default:
                break
            }
        }
        
        .alert(isPresented: self.$loginErrorAlert, content: {
            Alert(title: Text("Error"), message: Text(self.loginErrorAlertMsg), dismissButton: .default(Text("Close")))
        })
    }
}

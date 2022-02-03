//
//  SessionStore.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Logged In UUID: \(user.uid)")
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    provider: user.providerID
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    // MARK: Signup
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    // MARK: SignIn
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    // MARK: SignOut
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    // MARK: Unbind
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: GetUser
    func getUser() -> User {
        let user = Auth.auth().currentUser
        var profile: User
        if let user = user {
            profile = User(uid: user.uid, displayName: user.displayName, email: user.email, provider: user.providerID)
            return profile
        } else {
            return User(uid: "n/a", displayName: nil, email: nil, provider: nil)
        }
    }
    
    // ---- USER SETTING ----
    
    // MARK: Send Confirm Eamil
    func updateEmail(to: String, handler: ((Error?) -> Void)?) {
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: to, completion: handler)
    }
    
    // MARK: Update Pwd
    func updatePassword(pwd: String, handler: ((Error?) -> Void)?) {
        Auth.auth().currentUser?.updatePassword(to: pwd, completion: handler)
    }
    
    // MARK: Delete Account
    func deleteAccount(handler: ((Error?) -> Void)?) {
        Auth.auth().currentUser?.delete(completion: handler)
    }
    
    // MARK: Login with Credential
    func credentialLogin(credential: AuthCredential, handler:((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(with: credential, completion: handler)
    }
    
    // MARK: Get Provider
    func getProvider() -> [String]? {
        let providerIds = Auth.auth().currentUser?.providerData.map { $0.providerID }
        return providerIds
    }
    
    // MARK: Update Display Name
    func updateName(to: String, handler: ((Error?) -> Void)?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = to
        changeRequest?.commitChanges(completion: handler)
    }
    
    // Provider Type
    struct AuthProviders {
        static let phone    = "phone"
        static let apple    = "apple"
    }
}

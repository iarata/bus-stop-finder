//
//  User.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import Foundation

class User: ObservableObject {
    @Published var uid: String
    @Published var email: String?
    @Published var displayName: String?
    @Published var provider: String?

    init(uid: String, displayName: String?, email: String?, provider: String?) {
        self.uid         = uid
        self.email       = email
        self.displayName = displayName
        self.provider    = provider
    }

}

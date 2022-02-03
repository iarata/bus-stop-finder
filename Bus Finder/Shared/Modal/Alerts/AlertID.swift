//
//  AlertID.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/07/06.
//

import SwiftUI

struct BAlert: Identifiable {
    var id: AlertType
    var title: String
    var message: String
    var primary: Alert.Button?
    var secondary: Alert.Button?
    
    /// This init makes an object with only title and message.
    ///
    /// ```
    /// BAlert(.error, message: "An error occured! Please try again later.")
    /// ```
    ///
    /// - Warning: Use this init with only `.error` and `.success` alerts
    /// - Parameter type: [AlertType] Type of alert
    /// - Parameter message: [String] Message of the alert
    init(_ type:AlertType, title: String, message: String) {
        self.id = type
        self.title = title
        self.message = message
        self.primary = nil
        self.secondary = nil
    }
    
    init(_ type: AlertType, title: String, message: String, primary: Alert.Button, secondary: Alert.Button) {
        self.id = type
        self.title = title
        self.message = message
        self.primary = primary
        self.secondary = secondary
    }
    
    enum AlertType {
        case error
        case success
        case custom
    }
}

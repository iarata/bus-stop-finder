//
//  Auth.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import Foundation

class AuthInit: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}


// MARK: Email Validation
extension String {
    func isValidEmail() -> Bool {
        guard !self.lowercased().hasPrefix("mailto:") else { return false }
        guard let emailDetector  = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {  return false }
        let matches  = emailDetector.matches(in: self, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else { return false }
        return matches[0].url?.scheme == "mailto"
    }
}

//
//  View.swift
//  Bus Finder (iOS)
//
//  Created by Alireza Hajebrahimi on 2021/06/13.
//

import SwiftUI

// MARK: - if condition
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}


// MARK: - snapshot
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
    /// Returns a String value indicating whether the current language is English or Japanese.
    ///
    /// - Parameters:
    ///   - str: A string from Bundle.main.preferredLocalizations.first
    func getCurrentLanguage(str: String) -> String {
        switch str {
        case "en":
            return "English"
        case "ja":
            return "日本語"
        default:
            return "-"
        }
    }
}

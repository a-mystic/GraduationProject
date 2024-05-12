//
//  UtilityViews.swift
//  GraduationProject
//
//  Created by a mystic on 12/8/23.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

extension Dictionary.Values where Element == Double {
    func mean() -> Double {
        let sum = self.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        return sum / Double(self.count)
    }
}

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

enum ServerState {
    case good
    case bad
    case loading
}

var currentDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let currentDate = Date()
    return dateFormatter.string(from: currentDate)
}

extension Dictionary.Values where Element == Double {
    func mean() -> Double {
        let sum = self.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        return sum / Double(self.count)
    }
}

extension Dictionary.Values where Element == [String] {
    var isCompletlyEmpty: Bool {
        var sum = ""
        for s in self {
            for c in s {
                sum += c
            }
        }
        return sum.isEmpty
    }
}

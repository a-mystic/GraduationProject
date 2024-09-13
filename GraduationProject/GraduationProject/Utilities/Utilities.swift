//
//  UtilityViews.swift
//  GraduationProject
//
//  Created by a mystic on 12/8/23.
//

import SwiftUI
import SafariServices
import CoreGraphics

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

extension Array where Element == Double {
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

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

struct Pie: Shape {
    var startAngle: Angle = Angle.zero
    var endAngle: Angle
    var clockwise = true
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.radians, endAngle.radians) }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
}

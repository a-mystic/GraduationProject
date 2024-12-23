//
//  FaceAnchor.swift
//  GraduationProject
//
//  Created by a mystic on 11/20/23.
//

import ARKit

protocol FaceAnchorDelegate: AnyObject {
    func updateExpression(expression: String)
}

final class FaceAnchor: NSObject {
    weak var delegate: FaceAnchorDelegate?
    
    private var expression = ""
    
    func analyze(faceAnchor: ARFaceAnchor) {
        mouth(faceAnchor)
        eyebrow(faceAnchor)
        mouthAndeyes(faceAnchor)
    }
    
    private func mouth(_ faceAnchor: ARFaceAnchor) {
        let mouthSmileLeft = faceAnchor.blendShapes[.mouthSmileLeft] as? CGFloat ?? 0
        let mouthSmileRight = faceAnchor.blendShapes[.mouthSmileRight] as? CGFloat ?? 0
        let mouthFrownLeft = faceAnchor.blendShapes[.mouthFrownLeft] as? CGFloat ?? 0
        let mouthFrownRight = faceAnchor.blendShapes[.mouthFrownRight] as? CGFloat ?? 0
        let smile = (mouthSmileLeft + mouthSmileRight) / 2
        let frown = (mouthFrownLeft + mouthFrownRight) / 2
        DispatchQueue.main.async { [weak self] in
            self?.isSmile(value: smile)
            self?.isFrown(value: frown)
        }
    }
    
    private func eyebrow(_ faceAnchor: ARFaceAnchor) {
        let browDownLeft = faceAnchor.blendShapes[.browDownLeft] as? CGFloat ?? 0
        let browDownRight = faceAnchor.blendShapes[.browDownRight] as? CGFloat ?? 0
        let fret = (browDownLeft + browDownRight) / 2
        DispatchQueue.main.async { [weak self] in
            self?.isFret(value: fret)
        }
    }
    
    private func mouthAndeyes(_ faceAnchor: ARFaceAnchor) {
        let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? CGFloat ?? 0
        let jawOpen = faceAnchor.blendShapes[.jawOpen] as? CGFloat ?? 0
        let eyeWideLeft = faceAnchor.blendShapes[.eyeWideLeft] as? CGFloat ?? 0
        let eyeWideRight = faceAnchor.blendShapes[.eyeWideRight] as? CGFloat ?? 0
        let openValue = (mouthFunnel + jawOpen + eyeWideLeft + eyeWideRight) / 4
        DispatchQueue.main.async { [weak self] in
            self?.isSurprise(value: openValue)
        }
    }

    
    private func isSmile(value: CGFloat) {
        switch value {
        case 0.5..<1: 
            expression = "😁"
        case 0.2..<0.5:
            expression = "🙂"
        default: 
            expression = ""
        }
        delegate?.updateExpression(expression: expression)
    }
    
    private func isFrown(value: CGFloat) {
        switch value {
        case 0.11..<1:
            expression = "🙁"
        default:
            break
        }
        delegate?.updateExpression(expression: expression)
    }
    
    private func isFret(value: CGFloat) {
        switch value {
        case 0.45..<1:
            expression = "😡"
        case 0.25..<0.45:
            expression = "😠"
        default: 
            break
        }
        delegate?.updateExpression(expression: expression)
    }
    
    private func isSurprise(value: CGFloat) {
        switch value {
        case 0.2..<1: 
            expression = "😮"
        default: 
            break
        }
        delegate?.updateExpression(expression: expression)
    }
}

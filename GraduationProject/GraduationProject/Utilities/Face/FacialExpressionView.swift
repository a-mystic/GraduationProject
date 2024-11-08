//
//  FacialExpressionView.swift
//  GraduationProject
//
//  Created by a mystic on 11/20/23.
//

import UIKit
import SwiftUI
import ARKit
import RealityKit

final class FacialExpressionController: UIViewController {
    private let arView = ARView(frame: .zero)
    private let emotionManager = FaceEmotionManager.shared
    
    @Binding var expression: String
    @Binding var expressionsOfRecognized: Set<String>
    
    init(expression: Binding<String>, expressionsOfRecognized: Binding<Set<String>>) {
        _expression = expression
        _expressionsOfRecognized = expressionsOfRecognized
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.arView.session.pause()
        self.arView.removeFromSuperview()
    }
    
    private lazy var face: FaceAnchor = {
        return FaceAnchor()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isARTrackingSupported {
            requestPermission()
        } else {
            print("ARTrackingSupported error")
        }
        self.view.addSubview(arView)
    }
    
    private var isARTrackingSupported: Bool {
        ARFaceTrackingConfiguration.isSupported
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
            if accessGranted {
                DispatchQueue.main.async {
                    self?.setUp()
                }
            } else {
                print("videoManager request error")
            }
        }
    }
    
    private func setUp() {
        let configuration = ARFaceTrackingConfiguration()
        arView.frame = view.frame
        arView.session.run(configuration)
        arView.session.delegate = self
        face.delegate = self
        self.view.addSubview(self.arView)
    }
}

extension FacialExpressionController: ARSessionDelegate, FaceAnchorDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let faceAnchor = anchor as? ARFaceAnchor {
                face.analyze(faceAnchor: faceAnchor)
            }
        }
    }
    
    func updateExpression(expression: String) {
        self.expression = expression
        self.expressionsOfRecognized.insert(expression)
        emotionManager.setEmotion(expression)
    }
}

struct FacialExpressionViewRefer: UIViewControllerRepresentable {
    @Binding var expression: String
    @Binding var expressionsOfRecognized: Set<String>

    func makeUIViewController(context: Context) -> FacialExpressionController {
        return FacialExpressionController(expression: $expression, expressionsOfRecognized: $expressionsOfRecognized)
    }
    
    func updateUIViewController(_ uiViewController: FacialExpressionController, context: Context) { }
}

struct FacialExpressionView: View {
    @State private var expression = ""
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FacialExpressionViewRefer(expression: $expression, expressionsOfRecognized: $expressionsOfRecognized)
                currentExpression
            }
        }
    }
    
    @State private var expressionsOfRecognized = Set<String>()
    
    var currentExpression: some View {
        VStack {
            Text(expression)
                .frame(alignment: .bottom)
                .font(.system(size: 200))
            Spacer().frame(height: 20)
        }
    }
}

//
//  ImageCaptureARView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-09-14.
//

import SwiftUI
import RealityKit
import ARKit

struct ImageCaptureARView: View {
    private let arView: ARView = ARView(frame: .zero)
    @State private var isCapturing: Bool = false
    
    var body: some View {
        ZStack {
            ARViewRepresentable(arView: arView)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                if isCapturing {
                    ProgressView()
                        .padding(.bottom)
                } else {
                    Button(action: {
                        isCapturing = true
                        Task {
                            do {
                                let frame = try await arView.session.captureHighResolutionFrame()
                                print(frame.capturedImage)
                            } catch {
                                print(error)
                            }
                            isCapturing = false
                        }
                    }, label: {
                        Text("Capture")
                    })
                    .buttonStyle(.bordered)
                    .background(.ultraThickMaterial)
                    .padding(.bottom)
                }
            }
        }
    }
}


private struct ARViewRepresentable: UIViewRepresentable {
    let arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        if let videoFormat = ARConfiguration.recommendedVideoFormatForHighResolutionFrameCapturing {
            configuration.videoFormat = videoFormat
        }
        
        arView.session.run(configuration)
                              
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {}
    
    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator(self)
    }
}

private class ARViewCoordinator: NSObject, ARSessionDelegate {
    let parent: ARViewRepresentable
    
    init(_ parent: ARViewRepresentable) {
        self.parent = parent
    }
}

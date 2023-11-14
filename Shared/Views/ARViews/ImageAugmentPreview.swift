//
//  ImageAugmentPreview.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-27.
//

import SwiftUI
import RealityKit
import Combine
import VarInt

struct ImageAugmentPreview: View {
    private let arView: ARView = ARView(frame: .zero)
    private let imageURI = URL(fileURLWithPath: Bundle.main.path(forResource: "sample-logo", ofType: "png")!)
    
    @State var cancellable: Cancellable? = nil

    var body: some View {
        AugmentCameraViewRepresentable(arView: arView, inputComponents: [[PositionCom.self]])
            .onAppear {
                cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                    guard let entity = event.scene.findEntity(named: "1") else { return }
                                                        
                    entity.components.set(
                        ImageCom(uniqueKey: "0", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), encodingFormat: .Png, physicalWidthInMillimeters: 500, contentURI: imageURI.absoluteString)
                    )
                }
            }
            .onDisappear {
                cancellable?.cancel()
                arView.session.pause()
            }
    }
}

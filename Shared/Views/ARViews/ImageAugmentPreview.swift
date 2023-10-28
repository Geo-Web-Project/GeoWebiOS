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
    private let imageData = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sample-logo", ofType: "png")!))
    
    @State var cancellable: Cancellable? = nil

    var body: some View {
        AugmentInputViewRepresentable(arView: arView, inputComponents: [[Transform.self]])
            .onAppear {
                cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                    guard let entity = event.scene.findEntity(named: "0") else { return }
                                    
                    let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + imageData))
                    
                    entity.components.set(
                        ImageCom(physicalWidthInMillimeters: 500, contentHash: contentHash, encodingFormat: .Png)
                    )
                }
            }
            .onDisappear {
                cancellable?.cancel()
            }
    }
}

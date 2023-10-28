//
//  ModelAugmentPreview.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-27.
//

import SwiftUI
import RealityKit
import GLTFKit2
import VarInt
import Combine

struct ModelAugmentPreview: View {
    private let arView: ARView = ARView(frame: .zero)
    private let contentHash: Data = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + (try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "buddha", ofType: "glb")!)))))

    @State var cancellable: Cancellable? = nil

    var body: some View {
        AugmentInputViewRepresentable(arView: arView, inputComponents: [[Transform.self]])
            .onAppear {
                cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                    guard let entity = event.scene.findEntity(named: "0") else { return }
                                
                    print("SET CONTENT")
                    entity.components.set(
                        ModelCom(contentHash: contentHash, encodingFormat: .Glb)
                    )
                    
                    cancellable?.cancel()
                }
            }
            .onDisappear {
                cancellable?.cancel()
                arView.session.pause()
            }
    }
}

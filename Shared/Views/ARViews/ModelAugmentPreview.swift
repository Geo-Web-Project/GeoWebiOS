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
import SwiftData

struct ModelAugmentPreview: View {
    @Environment(\.modelContext) private var context: ModelContext

    private let arView: ARView = ARView(frame: .zero)
    private let contentHash: Data = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + (try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "geoweb", ofType: "glb")!)))))

    @State var cancellable: Cancellable? = nil

    var body: some View {
        AugmentCameraViewRepresentable(arView: arView, inputComponents: [[PositionCom.self]], overlayText: Binding.constant(""))
            .onAppear {
                cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                    guard let entity = event.scene.findEntity(named: "1") else { return }
                    
                    let modelComs = try? context.fetch(FetchDescriptor<ModelCom>())
                    if let modelComs, modelComs.isEmpty {
                        let modelCom = ModelCom(uniqueKey: "1", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), contentHash: contentHash, encodingFormat: .Glb)
                        context.insert(modelCom)
                        entity.components.set(
                            modelCom
                        )
                    }
                    
                    cancellable?.cancel()
                }
            }
            .onDisappear {
                cancellable?.cancel()
                arView.session.pause()
            }
    }
}

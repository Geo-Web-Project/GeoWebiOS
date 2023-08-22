//
//  ModelSceneView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import SceneKit
import SwiftGLTF

enum ModelType {
    case usdz
    case glb
}

struct ModelSceneView: View {
    var qLAvailable: Bool = false
    @State var scene: SCNScene? = nil
//    @State var isPresentingQL: Bool = false
    
    var body: some View {
        ZStack {
            if let scene = scene {
                ClearSceneView(scene: SCNScene(named: "robot.usdz")!)
            }
            if (qLAvailable) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
//                            isPresentingQL = true
                        }, label: {
                            Label("Expand", systemImage: "viewfinder").labelStyle(.iconOnly)
                        })
                        .padding(10)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                }
            }
        }
//        .sheet(isPresented: $isPresentingQL) {
//            ModelQLView(url: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!))
//        }
        .task {
            scene = SCNScene(named: "robot.usdz")!
        }
    }
}

struct ClearSceneView: UIViewRepresentable {
    typealias UIViewType = SCNView
    typealias Context = UIViewRepresentableContext<ClearSceneView>

    let scene: SCNScene
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    func makeUIView(context: Context) -> UIViewType {
        let view = SCNView()
        view.backgroundColor = UIColor.clear
        view.autoenablesDefaultLighting = true
        view.scene = scene
//        
//        if modelType == .usdz {
//            view.scene = SCNScene(named: "robot.usdz")!
//        } else  {
//            let url = Bundle.main.url(forResource: "buddha", withExtension: "glb")!
//            let container = try! Container(url: url)
//            view.scene = try! SceneKitGenerator(document: container.document).generateSCNScene()
//        }
//        
        return view
    }
}

#Preview {
    ModelSceneView()
}

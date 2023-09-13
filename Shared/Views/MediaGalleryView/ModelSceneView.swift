//
//  ModelSceneView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import SceneKit
import GLTFKit2
import QuickLook

enum ModelType {
    case usdz
    case glb
}

struct ModelSceneView: View {
    var mediaObject: MediaObject
    var qLAvailable: Bool = false
    @State var scene: SCNScene? = nil
    @State var qlPreviewItem: QLPreviewItem? = nil
    @State var isPresentingQL: Bool = false
    
    var body: some View {
        ZStack {
            if let scene {
                ClearSceneView(scene: scene)
            } else {
                ProgressView()
            }
            if (qLAvailable) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingQL = true
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
        .sheet(isPresented: $isPresentingQL) {
            if let qlPreviewItem {
                ModelQLView(qlPreviewItem: qlPreviewItem)
            }
        }
        .task {
            guard let contentUrl = mediaObject.contentUrl else { return }
            if contentUrl.isFileURL {
                // Load local file
                
                switch mediaObject.encodingFormat {
                case .Glb:
                    let asset = try! GLTFAsset(url: contentUrl)
                    scene = SCNScene(gltfAsset: asset)
                    qlPreviewItem = contentUrl as NSURL
                case .Usdz:
                    scene = try? SCNScene(url: contentUrl)
                    qlPreviewItem = contentUrl as NSURL
                default:
                    return
                }
                
            } else {
                // Load remote URL
                do {
                    let (url, response) = try await URLSession.shared.download(for: URLRequest(url: contentUrl, cachePolicy: .returnCacheDataElseLoad))
                    
                    var tmpUrl = url
                    if let suggestedFilename = response.suggestedFilename {
                        let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                        
                        // Rename with suggested name
                        try? FileManager.default.moveItem(at: url, to: newUrl)
                        
                        tmpUrl = newUrl
                    }
                    
                    switch mediaObject.encodingFormat {
                    case .Glb:
                        let asset = try! GLTFAsset(url: tmpUrl)
                        scene = SCNScene(gltfAsset: asset)
                        qlPreviewItem = tmpUrl as NSURL
                    case .Usdz:
                        scene = try? SCNScene(url: tmpUrl)
                        qlPreviewItem = tmpUrl as NSURL
                    default:
                        return
                    }
                } catch {
                    print(error)
                }
            }
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

//#Preview {
//    ModelSceneView(modelURL: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!))
//}

//
//  ModelSceneView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import SceneKit
import SwiftGLTF
import QuickLook

enum ModelType {
    case usdz
    case glb
}

struct ModelSceneView: View {
    var modelURL: URL
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
            if modelURL.isFileURL {
                // Load local file
                scene = try? SCNScene(url: modelURL)
                qlPreviewItem = modelURL as NSURL
            } else {
                // Load remote URL
                let task = URLSession.shared.downloadTask(with: URLRequest(url: modelURL, cachePolicy: .returnCacheDataElseLoad)) { (url, response, error) in
                    if let error {
                        print(error)
                        return
                    }
                    guard let url = url else { return }
                    
                    if let suggestedFilename = response?.suggestedFilename {
                        let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                        
                        // Rename with suggested name
                        try? FileManager.default.moveItem(at: url, to: newUrl)
                        
                        scene = try? SCNScene(url: newUrl)
                        qlPreviewItem = newUrl as NSURL
                    } else {
                        scene = try? SCNScene(url: url)
                        qlPreviewItem = url as NSURL
                    }
                   
                    
                }
                
                task.resume()
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

#Preview {
    ModelSceneView(modelURL: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!))
}

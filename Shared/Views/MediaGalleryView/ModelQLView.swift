//
//  ModelQLView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import UIKit
import QuickLook
import ARKit

struct ModelQLView: UIViewControllerRepresentable {
    let qlPreviewItem: QLPreviewItem
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
        
    func makeCoordinator() -> ModelQLCoordinator {
        return ModelQLCoordinator(parent: self)
    }
    
    func updateUIViewController(
        _ uiViewController: QLPreviewController, context: Context) {}
}

class ModelQLCoordinator: QLPreviewControllerDataSource {
    let parent: ModelQLView
    
    init(parent: ModelQLView) {
        self.parent = parent
    }
    
    func numberOfPreviewItems(
        in controller: QLPreviewController
    ) -> Int {
        return 1
    }
    
    func previewController(
        _ controller: QLPreviewController,
        previewItemAt index: Int
    ) -> QLPreviewItem {
        return parent.qlPreviewItem
    }
    
}

#Preview {
    ModelQLView(qlPreviewItem: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!) as NSURL)
}

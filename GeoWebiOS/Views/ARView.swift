//
//  ARView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import SwiftUI
import SwiftData

struct ARView: View {
    var worldAddress: String

    private var model3DPredicate: Predicate<Model3DComponent> {
        #Predicate<Model3DComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var positionPredicate: Predicate<PositionComponent> {
        #Predicate<PositionComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var anchorPredicate: Predicate<AnchorComponent> {
        #Predicate<AnchorComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    @Query private var modelComponents: [Model3DComponent]
    @Query private var positionComponents: [PositionComponent]
    @Query private var anchorComponents: [AnchorComponent]

    init(worldAddress: String) {
        self.worldAddress = worldAddress

        _modelComponents = Query(filter: model3DPredicate)
        _positionComponents = Query(filter: positionPredicate)
        _anchorComponents = Query(filter: anchorPredicate)
    }
    
    var body: some View {
        ForEach(positionComponents) { pos in
            Text("\(pos.x), \(pos.y), \(pos.z)")
        }
        ForEach(anchorComponents) { anchor in
            Text(anchor.anchor.toHexString())
        }
        if let model = modelComponents.first, let usdzUrl = model.usdzUrl {
            ModelSceneView(modelURL: usdzUrl)
        }
    }
}

#Preview {
    ARView(worldAddress: "")
}

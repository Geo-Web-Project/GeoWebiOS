//
//  WorldListItemView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI
import SwiftData
import MapKit

struct WorldListItemView: View {
    var worldAddress: String
    
    private var namePredicate: Predicate<Name> {
        #Predicate<Name> { name in
            name.worldAddress == worldAddress
        }
    }
    private var urlPredicate: Predicate<Url> {
        #Predicate<Url> { url in
            url.worldAddress == worldAddress
        }
    }
    private var mediaObjectPredicate: Predicate<MediaObject> {
        #Predicate<MediaObject> { mediaObject in
            mediaObject.worldAddress == worldAddress
        }
    }
    private var anchorPredicate: Predicate<AnchorComponent> {
        #Predicate<AnchorComponent> { anchorComponent in
            anchorComponent.worldAddress == worldAddress
        }
    }
    
    @Query private var name: [Name]
    @Query private var url: [Url]
    @Query private var mediaObjects: [MediaObject]
    @Query private var anchorComponent: [AnchorComponent]

    private var hasWebContent: Bool {
        url.count > 0
    }
    private var hasMediaGallery: Bool {
        mediaObjects.count > 0
    }
    private var hasARContent: Bool {
        anchorComponent.count > 0
    }
    
    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _name = Query(filter: namePredicate)
        _url = Query(filter: urlPredicate)
        _mediaObjects = Query(filter: mediaObjectPredicate)
        _anchorComponent = Query(filter: anchorPredicate)
    }
    
    var body: some View {
        HStack {
            if let nameValue = name.first?.value {
                VStack(alignment: .leading) {
                    Text(nameValue)
                        .font(.title2)
                        .bold()
                }
                Spacer()
                GroupBox {
                    Grid {
                        GridRow {
                            Image(systemName: "safari")
                                .foregroundStyle(hasWebContent ? .primary : .quaternary)
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundStyle(hasMediaGallery ? .primary : .quaternary)
                        }.padding(.bottom)
                        GridRow {
                            Image(systemName: "viewfinder")
                                .foregroundStyle(hasARContent ? .primary : .quaternary)
                        }
                    }
                }
                .backgroundStyle(.thinMaterial)
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }.frame(minHeight: 100)
    }
}

#Preview {
    WorldListItemView(worldAddress: "")
}

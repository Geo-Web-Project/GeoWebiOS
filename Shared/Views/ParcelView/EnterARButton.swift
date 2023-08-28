//
//  EnterARButton.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct EnterARButton: View {
    @State var isPresentingAR: Bool = false
    
    var body: some View {
        Button(action: {
            isPresentingAR = true
        }, label: {
            Label("Enter AR", systemImage: "viewfinder")
        })
        .buttonStyle(.borderedProminent)
        .font(.title)
        .padding()
        .sheet(isPresented: $isPresentingAR) {
            ModelQLView(qlPreviewItem: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!) as NSURL)
        }
    }
}

#Preview {
    EnterARButton()
}

//
//  EnterARButton.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import SwiftUI


struct EnterARButton: View {
    var worldAddress: String
    @State private var isPresentingAR: Bool = false
    
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
            ARView(worldAddress: worldAddress)
        }
    }
}

#Preview {
    EnterARButton(worldAddress: "")
}

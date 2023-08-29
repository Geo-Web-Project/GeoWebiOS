//
//  AddWorldFormView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI

struct AddWorldFormView: View {
    var submit: (Int, String) -> Void
    var cancel: () -> Void
    
    private let chainId: String = "420"
    @State private var worldAddress: String = ""
    
    private var isReady: Bool {
        worldAddress.count > 0
    }
    
    var body: some View {
        Form {
            Section("Chain ID") {
                TextField(text: Binding.constant(chainId), label: {
                    Text("Chain ID")
                })
                .disabled(true)
                .keyboardType(.numberPad)
            }
            
            Section("World Address") {
                TextField(text: $worldAddress, label: {
                    Text("0x")
                })
            }
            
            Section {
                Button("Add World", action: {
                    submit(Int(chainId)!, worldAddress)
                })
                    .disabled(!isReady)
                
                Button("Cancel", action: {
                    cancel()
                })
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    AddWorldFormView(submit: { _, _ in }, cancel: {})
}

//
//  AddWorldFormView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI

struct AddWorldFormView: View {
    @Binding var isPresented: Bool
    
    @State private var rpcAddress: String = ""
    @State private var worldAddress: String = ""
    
    private var isReady: Bool {
        rpcAddress.count > 0 && worldAddress.count > 0
    }
    
    var body: some View {
        Form {
            Section {
                TextField(text: $rpcAddress, label: {
                    Text("RPC Address")
                })
                    .keyboardType(.numberPad)
                
                TextField(text: $worldAddress, label: {
                    Text("World Address")
                })
            }
            
            Section {
                Button("Add World", action: {})
                    .disabled(!isReady)
                
                Button("Cancel", action: {
                    isPresented = false
                })
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    AddWorldFormView(isPresented: Binding.constant(true))
}

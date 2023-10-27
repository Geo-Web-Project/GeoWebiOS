////
////  EnterARButton.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-08-30.
////
//
//import SwiftUI
//
//
//struct EnterARButton: View {
//    var worldAddress: String
//    @State private var isPresentingAR: Bool = false
//    
//    var body: some View {
//        Button(action: {
//            isPresentingAR = true
//        }, label: {
//            Label("Enter AR", systemImage: "viewfinder")
//        })
//        .buttonStyle(.borderedProminent)
//        .font(.title)
//        .padding()
//        .fullScreenCover(isPresented: $isPresentingAR) {
//            NavigationStack {
//                WorldARView(worldAddress: worldAddress)
//                    .toolbar {
//                        ToolbarItem {
//                            Button(action: {
//                                isPresentingAR = false
//                            }, label: {
//                                Image(systemName: "xmark")
//                            })
//                            .buttonStyle(.bordered)
//                            .buttonBorderShape(.circle)
//                        }
//                    }
//            }
//        }
//    }
//}
//
//#Preview {
//    EnterARButton(worldAddress: "")
//}

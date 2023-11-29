//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView: View {
    @State private var selectedTab: Int? = nil
    private var selectedTabBinding: Binding<Int?> {
        Binding {
            selectedTab
        } set: { newValue in
            selectedTab = newValue
            if sheetDetent == nil {
                sheetDetent = .medium
            }
        }

    }
    @State private var sheetDetent: PresentationDetent? = nil

    private var isPresented: Bool {
        sheetDetent != nil
    }
    
    func calculateSheetHeight(geometry: GeometryProxy) -> CGFloat {
        switch sheetDetent {
        case .some(.large):
            return geometry.size.height + geometry.safeAreaInsets.top
        default :
            return geometry.size.height / 3
        }
    }
    
    func calculateSheetOffsetY(geometry: GeometryProxy) -> CGFloat {
        switch sheetDetent {
        case .some(.medium):
            return 0
        case .some(.large):
            return -geometry.safeAreaInsets.top
        default :
            return geometry.safeAreaInsets.bottom + (geometry.size.height / 3)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                
                if isPresented {
                    Color.black
                        .opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                selectedTab = nil
                                sheetDetent = nil
                            }
                        }
                }
                
                VStack {
                    Spacer()
                    VStack {
                        Capsule()
                            .fill(Color.secondary)
                            .frame(width: 30, height: 3)
                            .padding(10)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                        }
                    }
                    .background(Color.background)
                    .frame(height: calculateSheetHeight(geometry: geometry))
                    .offset(y: calculateSheetOffsetY(geometry: geometry))
                }

                TabBarEllipse(selectedTab: selectedTabBinding)
                    .offset(y: sheetDetent == .large ? -geometry.safeAreaInsets.top : 0)
            }
        }
    }
}

#Preview {
    TabSheetView()
}

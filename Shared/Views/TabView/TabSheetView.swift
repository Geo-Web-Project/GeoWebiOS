//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView: View {
    @State private var selectedTab: Int? = nil
    private var isPresented: Bool {
        selectedTab != nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            selectedTab = nil
                        }
                    }
                
                VStack {
                    Spacer()
                    Color.background
                        .ignoresSafeArea()
                        .frame(height: geometry.size.height / 3)
                        .offset(y: isPresented ? 0 : geometry.safeAreaInsets.bottom + (geometry.size.height / 3))
                }
                
                TabBarEllipse(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    TabSheetView()
}

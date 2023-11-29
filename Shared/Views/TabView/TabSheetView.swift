//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView: View {
    @State private var selectedTab = 1
    private var isPresented: Bool {
        selectedTab != 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Color.red
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

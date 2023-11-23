//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView: View {
    @State private var isPresented = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack {
                    Spacer()
                    Color.red
                        .ignoresSafeArea()
                        .frame(height: geometry.size.height / 3)
                        .offset(y: isPresented ? 0 : geometry.safeAreaInsets.bottom + (geometry.size.height / 3))
                }
                
                TabBarEllipse2(shrink: isPresented)
                    .onTapGesture {
                        withAnimation {
                            isPresented.toggle()
                        }
                    }
            }
        }
    }
}

#Preview {
    TabSheetView()
}

//
//  TabBarEllipse.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabBarEllipse: View {
    @Binding var selectedTab: Int?
    
    private var shrink: Bool {
        selectedTab != nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Ellipse()
                        .fill(.thinMaterial)
                        .frame(height: 200)
                        .offset(y: (shrink ? 135 : 120))
                    HStack {
                        Spacer()
                        Image(systemName: "list.bullet")
                            .scaleEffect(shrink ? 1.2 : 1.5)
                            .padding(.top, 30 - geometry.safeAreaInsets.bottom)
                            .offset(x: shrink ? 20 : 0)
                            .foregroundStyle(selectedTab == 0 ? Color.accentColor : Color.primary)
                            .onTapGesture {
                                withAnimation(shrink ? .none : .default) {
                                    selectedTab = 0
                                }
                            }
                        
                        Spacer()
                        Image(systemName: "arkit")
                            .scaleEffect(shrink ? 1.2 : 1.5)
                            .padding(.top, 30 - geometry.safeAreaInsets.bottom)
                            .offset(y: shrink ? -10 : -18)
                            .foregroundStyle(.secondary)
//                            .foregroundStyle(selectedTab == 1 ? Color.accentColor : Color.primary)
//                            .onTapGesture {
//                                withAnimation(shrink ? .none : .default) {
//                                    selectedTab = 1
//                                }
//                            }
                        
                        Spacer()
                        Image(systemName: "map")
                            .scaleEffect(shrink ? 1.2 : 1.5)
                            .padding(.top, 30 - geometry.safeAreaInsets.bottom)
                            .offset(x: shrink ? -20 : 0)
                            .foregroundStyle(selectedTab == 2 ? Color.accentColor : Color.primary)
                            .onTapGesture {
                                withAnimation(shrink ? .none : .default) {
                                    selectedTab = 2
                                }
                            }
                        Spacer()
                    }
                    .offset(y: geometry.safeAreaInsets.bottom + 50)
                }
            }
        }
    }
}

#Preview {
    TabBarEllipse(selectedTab: Binding.constant(nil))
}

#Preview {
    TabBarEllipse(selectedTab: Binding.constant(1))
}

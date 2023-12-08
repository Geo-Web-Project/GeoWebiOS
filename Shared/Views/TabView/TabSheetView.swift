//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView<Content>: View where Content: View {
    let content: Content
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
    
    private var navigationTitle: String {
        switch selectedTab {
        case 0:
            "Nearby"
        case 1:
            "Augment Publisher"
        default:
            ""
        }
    }

    private var isPresented: Bool {
        sheetDetent != nil
    }
    
    init(content: () -> Content) {
        self.content = content()
    }
    
    func calculateSheetHeight(geometry: GeometryProxy) -> CGFloat {
        switch sheetDetent {
        case .some(.large):
            return geometry.size.height + geometry.safeAreaInsets.top
        default :
            return max(geometry.size.height / 3, 320)
        }
    }
    
    func calculateSheetOffsetY(geometry: GeometryProxy) -> CGFloat {
        switch sheetDetent {
        case .some(.medium):
            return 0
        case .some(.large):
            return -geometry.safeAreaInsets.top
        default :
            return geometry.safeAreaInsets.bottom + calculateSheetHeight(geometry: geometry)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content
                    .frame(width: geometry.size.width)
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
                        ZStack(alignment: .top) {
                            if sheetDetent == .medium {
                                VStack {
                                    Capsule()
                                        .fill(Color.secondary)
                                        .frame(width: 30, height: 3)
                                        .padding(10)
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                if sheetDetent == .large {
                                    Button(action: {
                                        withAnimation {
                                            selectedTab = nil
                                            sheetDetent = nil
                                        }
                                    }) {
                                        Image(systemName: "chevron.down")
                                            .padding()
                                    }
                                    .foregroundStyle(Color.primary)
                                }
                                
                                Text(navigationTitle)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                    .animation(.none, value: navigationTitle)
                                Spacer()
                                
                                if sheetDetent == .medium {
                                    Button(action: {
                                        withAnimation {
                                            selectedTab = nil
                                            sheetDetent = nil
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .padding()
                                    }
                                    .foregroundStyle(Color.primary)
                                }
                            }
                        }
                        
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
    TabSheetView {
        Color.orange
    }
}

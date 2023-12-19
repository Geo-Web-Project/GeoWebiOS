//
//  TabSheetView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabSheetView<UContent, OContent>: View where UContent: View, OContent: View {
    let underContent: UContent
    let overContent: OContent
    @State private var selectedView: Int? = nil
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
        switch selectedView {
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
    
    init(@ViewBuilder underContent: () -> UContent, @ViewBuilder overContent: () -> OContent) {
        self.underContent = underContent()
        self.overContent = overContent()
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
                underContent
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
                            } completion: {
                                selectedView = nil
                            }
                        }
                }
                
                VStack {
                    Spacer()
                    VStack {
                        ZStack(alignment: .top) {
                            if sheetDetent != .large {
                                VStack {
                                    Capsule()
                                        .fill(Color.secondary)
                                        .frame(width: 30, height: 3)
                                        .padding(10)
                                    Spacer()
                                }
                            }
                            
                            VStack {
                                HStack {
                                    if sheetDetent == .large {
                                        Button(action: {
                                            withAnimation {
                                                selectedTab = nil
                                                sheetDetent = nil
                                            } completion: {
                                                selectedView = nil
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
                                    
                                    if sheetDetent != .large {
                                        Button(action: {
                                            withAnimation {
                                                selectedTab = nil
                                                sheetDetent = nil
                                            } completion: {
                                                selectedView = nil
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .padding()
                                        }
                                        .foregroundStyle(Color.primary)
                                    }
                                }
                                
                                overContent
                            }
                        }
                    }
                    .background(Color.background)
                    .clipShape(.rect(topLeadingRadius: 10, topTrailingRadius: 10))
                    .ignoresSafeArea()
                    .frame(height: calculateSheetHeight(geometry: geometry))
                    .offset(y: calculateSheetOffsetY(geometry: geometry))
                }

                TabBarEllipse(selectedView: $selectedView, selectedTab: selectedTabBinding)
                    .offset(y: sheetDetent == .large ? -geometry.safeAreaInsets.top : 0)
            }
        }
    }
}

#Preview {
    TabSheetView {
        Color.orange
    } overContent: {
        Color.green
    }
}

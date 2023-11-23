//
//  TabBarEllipse2.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabBarEllipse2: View {
    var shrink = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Ellipse()
                        .fill(.thickMaterial)
                        .frame(height: 200)
                        .offset(y: geometry.safeAreaInsets.bottom + (shrink ? 160 : 120))
                    HStack {
                        Spacer()
                        Image(systemName: "list.bullet")
                            .scaleEffect(shrink ? 1.0 : 1.5)
                            .padding(.top, 20)
                            .offset(x: shrink ? 30 : 0)
                        
                        Spacer()
                        Image(systemName: "arkit")
                            .scaleEffect(shrink ? 1.0 : 1.5)
                            .padding(.top, 20)
                            .offset(y: shrink ? -8 : -20)
                        
                        Spacer()
                        Image(systemName: "map")
                            .scaleEffect(shrink ? 1.0 : 1.5)
                            .padding(.top, 20)
                            .offset(x: shrink ? -30 : 0)
                        Spacer()
                    }
                    .offset(y: geometry.safeAreaInsets.bottom + (shrink ? 75 : 60))
                }
            }
        }
    }
}

#Preview {
    TabBarEllipse2()
}

#Preview {
    TabBarEllipse2(shrink: true)
}

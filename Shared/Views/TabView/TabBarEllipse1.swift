//
//  TabBarEllipse1.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-22.
//

import SwiftUI

struct TabBarEllipse1: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Ellipse()
                        .fill(Color("BackgroundColor"))
                        .frame(height: 200)
                        .offset(y: geometry.safeAreaInsets.bottom + 120)
                    HStack {
                        Spacer()
                        Image(systemName: "list.bullet")
                            .scaleEffect(1.5)
                            .padding(.top, 20)
                        
                        Spacer()
                        Image(systemName: "arkit")
                            .scaleEffect(1.5)
                            .padding(.top, 20)
                            .offset(y: -20)
                        
                        Spacer()
                        Image(systemName: "map")
                            .scaleEffect(1.5)
                            .padding(.top, 20)
                        Spacer()
                    }
                    .offset(y: geometry.safeAreaInsets.bottom + 60)
                }
            }
        }
    }
}

#Preview {
    TabBarEllipse1()
}

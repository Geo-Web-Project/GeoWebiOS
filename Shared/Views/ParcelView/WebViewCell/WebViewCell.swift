//
//  WebViewCell.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import WebKit
import SafariServices

struct WebViewCell: View {
    @State var uri: String
    
    var body: some View {
        WebViewCellVariant2(uri: uri)
    }
}

#Preview {
    WebViewCell(uri: "https://immersive-web.github.io")
        .padding()
}

#Preview {
    WebViewCell(uri: "https://immersive-web.github.io")
        .frame(width: 200, height: 200)
        .padding()
}

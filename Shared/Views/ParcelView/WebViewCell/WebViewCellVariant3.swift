//
//  WebViewCellVariant3.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import WebKit
import SafariServices

struct WebViewCellVariant3: View {
    @State var uri: String
    @State private var isPresentingWebView = false
    
    var body: some View {
        Button(action: {
            isPresentingWebView = true
        }, label: {
            GroupBox(label:
                Label("Website", systemImage: "safari")
                    .font(.caption)
                    .textCase(.uppercase)
            ) {
                HStack {
                    Label(
                        title: {
                            Text(uri)
                                .lineLimit(1)
                        },
                        icon: {
                            Image("sample-favicon")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .aspectRatio(1.0, contentMode: .fit)
                        }
                    ).padding(.vertical)
                    Spacer()
                }
            }
        })
        .sheet(isPresented: $isPresentingWebView) {
            SafariWebView(url: URL(string: uri)!)
                .ignoresSafeArea()

        }
    }
}

private struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

#Preview {
    WebViewCellVariant3(uri: "https://immersive-web.github.io")
        .padding()
}

#Preview {
    WebViewCellVariant3(uri: "https://immersive-web.github.io")
        .frame(width: 200, height: 200)
        .padding()
}

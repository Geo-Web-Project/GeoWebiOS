//
//  WebViewCellVariant2.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import WebKit
import SafariServices

struct WebViewCellVariant2: View {
    @State var uri: String
    @State private var isPresentingWebView = false
    
    var body: some View {
        Button(action: {
            isPresentingWebView = true
        }, label: {
            GroupBox(
                label: Label(
                    title: {
                        Text(uri.split(separator: "://")[1])
                            .lineLimit(1)
                    },
                    icon: {
                        Image(systemName: "safari")
                            .imageScale(.large)
                    }
                )
                .font(.subheadline)
                .bold()
            ) {
                WebView(request: URLRequest(url: URL(string: uri)!) )
            }
        })
        .sheet(isPresented: $isPresentingWebView) {
            SafariWebView(url: URL(string: uri)!)
                .ignoresSafeArea()

        }
    }
}

private struct WebView: UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.isUserInteractionEnabled = false
        Task.detached(priority: .background) {
            await view.load(request)
        }
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        Task.detached(priority: .background) {
            await uiView.load(request)
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
    WebViewCellVariant2(uri: "https://immersive-web.github.io")
        .padding()
}

#Preview {
    WebViewCellVariant2(uri: "https://immersive-web.github.io")
        .frame(width: 200, height: 200)
        .padding()
}

#Preview {
    WebViewCellVariant2(uri: "https://immersive-web.github.io")
        .frame(width: 300, height: 150)
        .padding()
}

//
//  WebViewCellVariant1.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import WebKit
import SafariServices

struct WebViewCellVariant1: View {
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
                            .font(.subheadline)
                            .bold()
                            .lineLimit(1)
                    },
                    icon: {
                        if (uri.contains("https://")) {
                            Image(systemName: "lock.fill")
                        }
                        Image("sample-favicon")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                )
            ) {
                WebView(request: URLRequest(url: URL(string: uri)!) )
            }
        })
        .aspectRatio(1.0, contentMode: .fit)
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
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
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
    WebViewCellVariant1(uri: "https://immersive-web.github.io")
        .padding()
}

#Preview {
    WebViewCellVariant1(uri: "https://immersive-web.github.io")
        .frame(width: 200, height: 200)
        .padding()
}

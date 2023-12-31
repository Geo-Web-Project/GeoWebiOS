//
//  AVObjectView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-25.
//

import SwiftUI
import AVKit

struct AVObjectView: View {
    @State var url: URL
    @State var isPlaying: Bool = false
    @State var player: AVPlayer?
    var showPlayButton: Bool = true
    
    var body: some View {
        VStack {
            if let player {
                VideoPlayer(player: player)
                
                if showPlayButton {
                    Button {
                        isPlaying ? player.pause() : player.play()
                        isPlaying.toggle()
                        player.seek(to: .zero)
                    } label: {
                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                            .padding()
                            .font(.title)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                let (url, response) = try await URLSession.shared.download(for: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
                                
                if let suggestedFilename = response.suggestedFilename {
                    let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                    
                    // Rename with suggested name
                    try? FileManager.default.moveItem(at: url, to: newUrl)
                    
                    player = AVPlayer(url: newUrl)

                } else {
                    player = AVPlayer(url: url)
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    AVObjectView(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
}

#Preview {
    AVObjectView(url: Bundle.main.url(forResource: "audio", withExtension: "mp3")!, showPlayButton: false)
}

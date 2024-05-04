//
//  ContentView.swift
//  swift ui 5
//
//  Created by Ann Dosova on 4.05.24.
//

import SwiftUI
import AVFoundation

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    private var player: AVAudioPlayer?
    
    public func play() {
        playSong(name: "verka-serdjuchka-vse-budet-khorosho")
        player?.play()
        
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }
    
    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3") else { return }
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var progress: Float = 0
    
    @ObservedObject var viewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
            Slider(value: Binding(get: {
                Double(progress)
            }, set: { newValue in
                progress = Float(newValue)
                viewModel.setTime(value: Float(newValue))
                
            }), in: 0...viewModel.maxDuration)
            
            HStack {
                Button(action: {
                    print("Play")
                    progress = 0
                    self.viewModel.play()
                }) {
                    Text("Play")
                        .foregroundColor(.white)
                }.frame(width: 100, height: 50)
                 .background(Color.orange)
                 .cornerRadius(10)
                
                Button(action: {
                    print("Stop")
                    self.viewModel.stop()
                }) {
                    Text("Stop")
                        .foregroundColor(.white)
                }.frame(width: 100, height: 50)
                 .background(Color.orange)
                 .cornerRadius(10)
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

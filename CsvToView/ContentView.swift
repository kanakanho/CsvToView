//
//  ContentView.swift
//  CsvToView
//
//  Created by blue ken on 2024/08/20.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @State private var playMIDIDatas: [PlayMIDIData] = []
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)
            
            Button("Let's Play!") {
                withAnimation {
                    print("play")
                    let csvDataHandler = CsvDataHandler(filepath:"notes_minuet_utf8_encoded")
                    csvDataHandler.printDataFrameContents()
                    let playDataHandler = PlayDataHandler(df: csvDataHandler.getDataFrame())
                    playMIDIDatas = playDataHandler.getPlayMIDIDatas()
                }
            }
            
            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    @State var playMIDIDatas = [PlayMIDIData(midiNoteData: 60, playing: [Playing(onsetTime: 0.0, duration: 1.0)])]
    ContentView()
}

//
//  PlayDataHandler.swift
//  CsvToView
//
//  Created by blue ken on 2024/08/20.
//

import Foundation
import TabularData

struct Playing {
    var onsetTime: Double
    var duration: Double
}

struct PlayMIDIData {
    var noteNumber: Int
    var noteName: String
    var playing: [Playing]
}

class PlayDataHandler :Identifiable{
    var playMIDIDatas: [PlayMIDIData] = []
    
    var isPlaying = false
    var startTime: Date?
    
    init(df: DataFrame) {
        let midiNoteNumberDf = df.sorted(on: "MIDI Note Number")
        var currentMidiNoteNumber = midiNoteNumberDf.rows[0]["MIDI Note Number"] as! Int
        
        for row in df.rows {
            guard let tmpMidiNoteNumber = row["MIDI Note Number"] as? Int else {
                print("MIDI Note Number が Int にキャストできませんでした。")
                return
            }
            if currentMidiNoteNumber != tmpMidiNoteNumber {
                currentMidiNoteNumber = tmpMidiNoteNumber
            }
            
            guard let onsetTime = row["Onset Time"] as? Double else {
                print("Start Time が Double にキャストできませんでした。")
                return
            }
            
            guard let duration = row["Duration"] as? Double else {
                print("Duration が Double にキャストできませんでした。")
                return
            }
            
            guard let noteName = row["Note Name"] as? String else {
                print("Note Name が String にキャストできませんでした。")
                return
            }
            
            let playing = Playing(onsetTime: onsetTime, duration: duration)
            
            if let index = playMIDIDatas.firstIndex(where: { $0.noteNumber == currentMidiNoteNumber }) {
                playMIDIDatas[index].playing.append(playing)
            } else {
                let playMIDIData = PlayMIDIData(noteNumber: currentMidiNoteNumber, noteName: noteName, playing: [playing])
                playMIDIDatas.append(playMIDIData)
            }
            
            printPlayMIDIDatas()
        }
    }
    
    func setStartTime(date:Date) {
        isPlaying = true
        startTime = date
    }
    
    func setEndTime(date:Date) {
        isPlaying = false
        startTime = nil
    }
    
    func nowPlaying(date:Date) -> [PlayMIDIData] {
        if (!isPlaying) {
            return []
        }
        
        var resultPlayMIDIDatas: [PlayMIDIData] = []
        
        // 入力されたDateがstartTime+onsetTimeからDurationの間に存在しているかを確認
        for playMIDIData in playMIDIDatas {
            var playing: [Playing] = []
            for play in playMIDIData.playing {
                if let startTime = startTime {
                    if startTime.timeIntervalSince1970 + play.onsetTime <= date.timeIntervalSince1970 &&
                       startTime.timeIntervalSince1970 + play.onsetTime + play.duration >= date.timeIntervalSince1970 {
                        playing.append(play)
                    }
                }
            }
            if playing.count > 0 {
                resultPlayMIDIDatas.append(PlayMIDIData(noteNumber: playMIDIData.noteNumber, noteName: playMIDIData.noteName, playing: playing))
            }
        }
        
        return resultPlayMIDIDatas
    }
    
    func getPlayMIDIDatas() -> [PlayMIDIData] {
        return playMIDIDatas
    }
    
    func printPlayMIDIDatas() {
        for playMIDIData in playMIDIDatas {
            print("midiNoteNumber: \(playMIDIData.noteNumber)\t noteName: \(playMIDIData.noteName)")
            for playing in playMIDIData.playing {
                // end time は 小数点 4桁で四捨五入
                print("start poke : \(playing.onsetTime)\t end poke : \(round((playing.onsetTime + playing.duration)*1000)/1000)\t duration : \(playing.duration)")
            }
            print("------------------------------------------------------------")
        }
    }
}

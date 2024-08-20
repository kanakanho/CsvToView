//
//  CsvToViewApp.swift
//  CsvToView
//
//  Created by blue ken on 2024/08/20.
//

import SwiftUI

@main
struct CsvToViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}

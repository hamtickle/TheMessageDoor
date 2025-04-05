//
//  TheMessageDoorApp.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import SwiftUI
import Firebase

@main
struct TheMessageDoorApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

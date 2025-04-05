//
//  AuthApp.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import Firebase
import SwiftUI

@main
struct AuthApp: App {

    init() {
        FirebaseApp.configure()
        print("Firebase configured.")
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}

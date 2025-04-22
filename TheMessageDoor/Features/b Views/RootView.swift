//
//  RootView.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import SwiftUI

struct RootView: View {

    @StateObject var pVM = ProfileViewModel()
    
    @State private var showSignInView: Bool = false


    var body: some View {
        ZStack {
            if !showSignInView {
                    TabBarView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil

        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

#Preview {
    RootView()
}

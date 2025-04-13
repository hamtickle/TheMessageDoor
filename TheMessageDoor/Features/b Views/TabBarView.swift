//
//  TabBarView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                MessageListView()
            }
                .tabItem{
                    Image(systemName: "door.right.hand.closed")
                    Text("Your Door")
                }
            
            NavigationStack {
                MessageView()
            }
                .tabItem{
                    Image(systemName: "paperplane")
                    Text("Message")
                }
            
            NavigationStack {
                OrderView()
            }
                .tabItem{
                    Image(systemName: "cart")
                    Text("Order")
                }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
            
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
                .tabItem{
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
  
       
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}

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
                ProfileView(showSignInView: $showSignInView)
            }
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
            NavigationStack {
                OrderView()
            }
                .tabItem{
                    Image(systemName: "cart")
                    Text("Order")
                }
            NavigationStack {
                MessageView()
            }
                .tabItem{
                    Image(systemName: "paperplane")
                    Text("Message")
                }
            
        }
       
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}

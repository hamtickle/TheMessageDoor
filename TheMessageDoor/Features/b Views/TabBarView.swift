//
//  TabBarView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct TabBarView: View {

    @StateObject var pVM = ProfileVM()
    @State var currentUser: Person = Person(userId: "")
   

    @State var refreshView = false
    @Binding var showSignInView: Bool
    @State var tabSelection: Int = 0
    @State var incompleteProfile: Bool = false
    

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                MessageListView(user: currentUser)
            }

            .tabItem {
                Image(systemName: "door.right.hand.closed")
                Text("Your Door")
          
            }
            .tag(0)
            .onAppear {

            }

            NavigationStack {
                CreateMessageView(tabSelection: $tabSelection)

            }

            .tabItem {
                Image(systemName: "paperplane")
                Text("Message")
                
            }
            .tag(1)

            NavigationStack {
                OrderListView(user: currentUser)

            }

            .tabItem {
                Image(systemName: "cart")
                Text("Order")
                   
            }
            .tag(2)

            NavigationStack {
                AchievementsView()
            }

            .tabItem {
                Image(systemName: "trophy")
                Text("Achievments")
            }
            .tag(3)

            NavigationStack {
                ProfileView(user: currentUser, showSignInView: $showSignInView)

            }

            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(4)

        }
        .onAppear {
//            let currentUser = GetCurrentUser.shared.appUser
//            print("TabBar onAppear: \(currentUser), First Name: \(currentUser.firstName)")
            if incompleteProfile
                {
                tabSelection = 4
                incompleteProfile = true
                refreshView = true
            }
        }
        .environmentObject(ProfileVM())
    }
        
        
}

#Preview {
    TabBarView(showSignInView: .constant(false))

}

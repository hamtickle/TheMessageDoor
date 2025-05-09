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
    @State var tabSelection: Int = 0
    
    
    @Binding var showSignInView: Bool
//    @Binding var showLoadingScreen: Bool
//    @Binding var incompleteProfile: Bool
    

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                MessageListView()
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
                OrderListView()

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
//            if incompleteProfile
//                {
//                tabSelection = 4
//                incompleteProfile = true
//                refreshView = true
            }
        }
     
    
        
        
}

#Preview {
    TabBarView(showSignInView: .constant(false))

}

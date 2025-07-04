//
//  TabBarView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct TabBarView: View {

    private var k: Constants = Constants()
    @StateObject var appUser: GetCurrentUser
    @State var user: Person = Person(userId: "")
   
//    @State var refreshView = false
    @State var tabSelection: Int
        
    @Binding var showSignInView: Bool
    @State var initialLoad: Bool = true
  

    
    init(showSignInView: Binding<Bool>) {
        _appUser = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _showSignInView = showSignInView
        _tabSelection = .init(initialValue: 0)
    }
    

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                MessageListView(initialLoad: $initialLoad)
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
                
                OrderListView(tabSelection: $tabSelection)

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
                ProfileView(showSignInView: $showSignInView)
                
            }
            
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(4)
            
        }
        .onAppear {
            user = appUser.fetchUserDefaults()
            print("TV: onAppear \(user)")
            if user.newUser
            {
                tabSelection = 4
            }
        }
        
        
    }
        
}

#Preview {
    TabBarView(showSignInView: .constant(false))

}

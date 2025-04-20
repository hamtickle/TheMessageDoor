//
//  TabBarView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct TabBarView: View {

    @StateObject var pVM = ProfileViewModel()
    @StateObject var mVM = MessageViewModel()
    @StateObject var oVM = OrderViewModel()

    @Binding var showSignInView: Bool
    @State var tabSelection: Int = 0

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                MessageListView(pVM: pVM, mVM: mVM)
            }

            .tabItem {
                Image(systemName: "door.right.hand.closed")
                Text("Your Door")
          
            }
            .tag(0)

            NavigationStack {
                CreateMessageView(pVM: pVM, mVM: mVM, oVM: oVM, tabSelection: $tabSelection)

            }

            .tabItem {
                Image(systemName: "paperplane")
                Text("Message")
                
            }
            .tag(1)

            NavigationStack {
                OrderListView(pVM: pVM)

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
                ProfileView(pVM: pVM, mVM: mVM, showSignInView: $showSignInView)

            }

            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(4)

        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))

}

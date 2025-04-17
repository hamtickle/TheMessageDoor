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

    var body: some View {
        TabView {
            NavigationStack {
                MessageListView(pVM: pVM, mVM: mVM)
            }

            .tabItem {
                Image(systemName: "door.right.hand.closed")
                Text("Your Door")
            }

            NavigationStack {
                MessageView(pVM: pVM, mVM: mVM, oVM: oVM)

            }

            .tabItem {
                Image(systemName: "paperplane")
                Text("Message")
            }

            NavigationStack {
                OrderListView(pVM: pVM)

            }

            .tabItem {
                Image(systemName: "cart")
                Text("Order")
            }

            NavigationStack {
                AchievementsView()
            }

            .tabItem {
                Image(systemName: "trophy")
                Text("Achievments")
            }

            NavigationStack {
                ProfileView(pVM: pVM, mVM: mVM, showSignInView: $showSignInView)

            }

            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }

        }

    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))

}

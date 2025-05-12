//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

    @StateObject var user: GetCurrentUser
    @StateObject var vm: MessageListVM

    @State private var messageFilter = 0
    @State var isSender: Bool = true
    @State var noMessages: Bool = false
    @State var reload: Bool = false
    @State var loading: Bool = false

    init() {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: MessageListVM())
    }

    var body: some View {

        VStack(alignment: .center) {
            Text("\(user.currentUser.firstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)
            Text("ID: \(user.currentUser.userId)")
                .font(.caption)
            Text("Total Messages: \(vm.displayMessages.count)")

            Picker("Filter", selection: $messageFilter) {
                Text("My Messages").tag(0)
                Text("Received Messages").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // The List

            List(vm.displayMessages) { message in
                NavigationLink(
                    destination: MessageDetail(
                        user: user.currentUser, message: message,
                        isSender: isSender, mlVM: MessageListVM())
                ) {
                    HStack {
                        MessageCell(message: message)
                            .frame(width: 300)
                            //                            .padding(.vertical, 0)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .listStyle(.plain)
            .onChange(of: messageFilter) { oldValue, newValue in
                if newValue == 0 {
                    do {
                        Task {
                            await vm.fetchSenderMessages(
                                senderId: user.currentUser.userId)
                        }
                        isSender = true
                    }
                } else {
                    do {
                        Task {
                            await vm.fetchReceiverMessages(
                                to: user.currentUser.email)
                        }
                        isSender = false
                    }
                }
            }
            .onChange(of: vm.reloadList) {
                Task {
                    await vm.fetchSenderMessages(
                        senderId: user.currentUser.userId)
                }

            }
            .onAppear {
                // looks like this is triggered when returning from navlink- so why isn't the list being rebuilt and shown on the view.  Investigate observalbe/state object pairs.
                loading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                    let appUser = user.currentUser
                    print("onAppear - now")

                    if appUser.firstName == "" {
                        user.getUserDefaults()
                    }

//                    if appUser.totalMessagesCreated == 0 {
//                        noMessages = true
//                    }
                
                    do {
                        Task {

                            await vm.fetchSenderMessages(
                                senderId: appUser.userId)
                            
                        }
                    }
                    loading = false
                }

            }
            .overlay {
                if loading {
                    ProgressView()
                }
            }
            //            .alert(isPresented: $noMessages,
            //                   content: {
            //                Alert(
            //                    title: Text("No Messages"),
            //                    message: Text("You have not created any messages yet."),
            //                    dismissButton: .cancel(Text("OK"))
            //                )
            //            })
        }
    }
}

#Preview {
    NavigationStack {

        MessageListView()
    }

}

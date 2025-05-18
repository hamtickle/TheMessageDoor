//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {
    
    private var k: Constants = Constants()
    @StateObject var user: GetCurrentUser
    @StateObject var vm: MessageListVM

    @State var messageFilter = 0
    @State var isSender: Bool = true
    @State var noMessages: Bool = false
    @State var reload: Bool = false
    @State var loading: Bool = false

    init() {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: MessageListVM())
        print("mLV: Init MessageListVM \n")
        if reload {
            loading = true
        }

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
                        isSender: isSender, reload: $reload)
                ) {
                    HStack {
                        MessageCell(message: message, isSender: isSender)
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
            //            .onChange(of: loading) {
            //                Task {
            //                    await vm.fetchSenderMessages(
            //                        senderId: user.currentUser.userId)
            //                }

            //            }
            .onDisappear {
                print("List View Disappeared \n")
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
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .onAppear {
            print("List View Appeared \n")
            // looks like this is triggered when returning from navlink- so why isn't the list being rebuilt and shown on the view.  Investigate observable/state object pairs.
            loading = true
            vm.displayMessages = []
            do {
                Task {

                    await vm.fetchSenderMessages(
                        senderId: user.currentUser.userId)

                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                //                let appUser = user.currentUser

                //                    if appUser.firstName == "" {
                //                        user.getUserDefaults()
                //                    }

                loading = false
            }

        }
    }
}

#Preview {
    NavigationStack {

        MessageListView()
    }

}

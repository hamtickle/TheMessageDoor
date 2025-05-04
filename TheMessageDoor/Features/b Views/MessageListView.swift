//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

//    @StateObject var pVM : ProfileVM
    @State var user: Person
    @EnvironmentObject var pVM : ProfileVM
    @StateObject var vm : MessageListVM = MessageListVM()

    @State private var messageFilter = 0
    @State var sender: Bool = true
    @State var noMessages: Bool = false

    var body: some View {

        VStack(alignment: .center) {
            Text("\(pVM.currentUser.firstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)
            Text("ID: \(pVM.currentUser.userId)")
                .font(.caption)
            Text("Total Messages: \(pVM.currentUser.totalMessagesCreated)")

            Picker("Filter", selection: $messageFilter) {
                Text("My Messages").tag(0)
                Text("Received Messages").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // The List

            List(vm.displayMessages) { message in
                NavigationLink(
                    destination: MessageDetail(user: user, message: message, sender: sender)
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
            .onChange(of: messageFilter) {oldValue, newValue in
                if newValue == 0 {
                    do {
                        Task {
                            await vm.fetchSenderMessages(
                                senderId: pVM.currentUser.userId)
                        }
                        sender = true
                    }
                } else {
                    do {
                        Task {
                            await vm.fetchReceiverMessages(
                                receiverId: pVM.currentUser.receiverKey)
                        }
                        sender = false
                    }
                }
            }
            .onChange(of: vm.reloadList) {
                Task {
                    await vm.fetchSenderMessages(
                        senderId: pVM.currentUser.userId)
                }
               
            }
            .onAppear {
                if pVM.currentUser.totalMessagesCreated == 0 {
                    noMessages = true
                }
                do {
                    Task {

                         await vm.fetchSenderMessages(
                            senderId: pVM.currentUser.userId)
                    }
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

        MessageListView(user: Person(userId: ""))
    }
  
}

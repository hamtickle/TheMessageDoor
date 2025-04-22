//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

    @StateObject var pVM : ProfileViewModel
    @StateObject var vm : MessageListVM = MessageListVM()

    @State private var messageFilter = 0
    @State var sender: Bool = true

    var body: some View {

        VStack(alignment: .center) {
            Text("\(pVM.currentUserFirstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)
            Text("Total Messages: \(vm.myTotalMessages)")

            Picker("Filter", selection: $messageFilter) {
                Text("My Messages").tag(0)
                Text("Received Messages").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // The List

            List(vm.displayMessages) { message in
                NavigationLink(
                    destination: MessageDetail(pVM: pVM, message: message, sender: sender)
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
            .onChange(of: messageFilter) { newValue in
                if newValue == 0 {
                    do {
                        Task {
                            await vm.fetchSenderMessages(
                                senderId: pVM.currentUserId)
                        }
                        sender = true
                    }
                } else {
                    do {
                        Task {
                            await vm.fetchReceiverMessages(
                                receiverId: pVM.currentUserId)
                        }
                        sender = false
                    }
                }
            }
            .onChange(of: vm.reloadList) {
                Task {
                    await vm.fetchSenderMessages(
                       senderId: pVM.currentUserId)
                }
               
            }
            .onAppear {

                do {
                    Task {
                        try? await pVM.loadCurrentUser()
                         await vm.fetchSenderMessages(
                            senderId: pVM.currentUserId)
                    }
                }

            }
     
        }
    }
}

#Preview {
    NavigationStack {

        MessageListView(pVM: ProfileViewModel())
    }
  
}

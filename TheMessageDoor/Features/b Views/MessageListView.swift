//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

    @StateObject var mVM = MessageViewModel()
    @StateObject private var pVM = ProfileViewModel()

    @State private var messageFilter = 0
    @State var sender: Bool = true

    var body: some View {

        VStack(alignment: .center) {
            Text("\(pVM.currentUserFirstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)
            Text("Total Messages: \(mVM.myTotalMessages)")

            Picker("Filter", selection: $messageFilter) {
                Text("My Messages").tag(0)
                Text("Received Messages").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // The List

            List(mVM.displayMessages) { message in
                NavigationLink(destination: MessageDetail(message: message, sender: sender)) {
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
                            try? await mVM.fetchSenderMessages(
                                senderId: pVM.currentUserId)
                        }
                        sender = true
                    }
                } else {
                    do {
                        Task {  try? await mVM.fetchReceiverMessages(
                            receiverId: pVM.currentUserId)
                        }
                        sender = false
                    }
                }
            }
            .onAppear {

                do {
                    Task {
                        try? await pVM.loadCurrentUser()
                        try await mVM.fetchSenderMessages(
                            senderId: pVM.currentUserId)
                    }
                }

            }

        }
    }
}

#Preview {
    MessageListView()
}

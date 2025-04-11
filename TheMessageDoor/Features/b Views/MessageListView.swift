//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

    @StateObject private var mVM = MessageViewModel()
    @StateObject private var pVM = ProfileViewModel()

    @State private var messageFilter = 0

    var body: some View {

        VStack(alignment: .center) {
            Text("\(pVM.currentUserFirstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)

            Picker("Filter", selection: $messageFilter) {
                Text("Sent Messages").tag(0)
                Text("Received Messages").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // The List

            List(mVM.displayMessages) { message in
                NavigationLink(destination: MessageDetail(messageId: message.messageId)) {
                    HStack {
                        MessageCell(message: message)
                            .frame(width: 300)
                            .padding(.vertical, 0)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .listStyle(.plain)
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

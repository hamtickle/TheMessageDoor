//
//  MessagePickers.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 6/29/25.
//

import SwiftUI

struct MessagePickers: View {

    @ObservedObject var vm: MessageVM

    @Binding var messageFilter: Int
    @Binding var myMessages: Int

    var body: some View {
        Picker("Filter", selection: $messageFilter) {
            Text("Sent Messages").tag(0)
            Text("Received Messages").tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)

        if messageFilter == 0 {
            Picker("SentMessages", selection: $myMessages) {
                Text("All").tag(0)
                Text("Favorites").tag(1)
                Text("Unsent").tag(2)
                Text("UnRead").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        } else {
            Picker("ReceivedMessages", selection: $myMessages) {
                Text("All").tag(0)
                Text("Favorites").tag(1)
                Text("Unread").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    MessagePickers(
        vm: MessageVM(), messageFilter: .constant(0), myMessages: .constant(0))
}

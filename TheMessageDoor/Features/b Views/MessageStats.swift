//
//  MessageStats.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/9/25.
//
import SwiftUI

struct MessageStats: View {
    var message: Message
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Message Stats")
                .font(.headline)
                .foregroundColor(
                    colorScheme == .dark ? .white : .black
                )
            HStack {
                Text("Sent:")
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.caption)
                Text(
                    message.dateSent,
                    format: Date.FormatStyle(date: .numeric)
                )
                .foregroundColor(
                    colorScheme == .dark ? .white : .black
                )
                .font(.caption)
            }
            HStack {
                Text("Status:")
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.caption)
                Text(
                    message.messageStatus
                )
                .foregroundColor(
                    colorScheme == .dark ? .white : .black
                )
                .font(.caption)
            }
            HStack {
                Text("Date Opened:")
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.caption)
            }
            HStack {
                Text("Recipient Favorite?:")
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.caption)
                if message.receiverFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(
                            colorScheme == .dark
                                ? .white : .black
                        )
                        .font(.caption)
                }

            }
            HStack {
                Text("Recipient Deleted?:")
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.caption)
                Text(
                    message.receiverDeleted.description
                )
                .foregroundColor(
                    colorScheme == .dark ? .white : .black
                )
                .font(.caption)
            }
        }
    }
}

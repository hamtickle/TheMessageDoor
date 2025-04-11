//
//  MessageCell.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageCell: View {

    @EnvironmentObject var mVM: MessageViewModel
    @State var message: Message

    var body: some View {

        HStack {

            // Image
            Spacer()
            Spacer()
            Image("Logo_TMD_large")
                .resizable()
                .frame(width: 50, height: 90)

            // Rectangle
            ZStack {
                Rectangle()
                    .fill(message.isSent ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color.white)
                    .frame(width: 270, height: 110)
                    .shadow(color: Color.gray, radius: 10, x: 10, y: 10)
                HStack {

                    VStack(alignment: .leading) {
                        Text(message.message)
                            .foregroundColor(Color.blue)
                            .font(.caption)
                            .lineLimit(1)
                            .bold()

                        Text(message.to)
                            .font(.body)
                            .foregroundColor(Color.black)

                        HStack {
                            Text("Saved:")
                                .font(.caption)
                                .foregroundColor(Color.black)
                            
                            Text(
                                message.dateSent,
                                format: Date.FormatStyle(date: .numeric)
                                )
                                .font(.caption)
                                .foregroundColor(Color.black)
                        }
                        
                        
                        HStack {
                            Text("Status:")
                                .font(.caption)
                                .foregroundColor(Color.black)
                            Text(message.isSent ? "Sent" : "Saved")
                                .font(.caption)
                                .foregroundColor(Color.black)
                        }
                        Text(message.messageId)
                            .font(.caption2)
                            .foregroundColor(Color.black)

                    }
                    Spacer()

                    VStack(alignment: .trailing) {
                        Spacer()
                        if message.senderFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "heart")
                        }
                        if message.receiverFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Text(message.isSent ? message.messageOpenedStatus : "")
                            .font(.caption)
                            .foregroundColor(Color.black)
                        Text(message.isSent ? "3/25/2025" : "")
                            .font(.caption)
                            .foregroundColor(Color.black)
                        Spacer()
                    }

                }
                .padding()

            }
        }
        .padding(.horizontal, 30)
    }
        
}

//#Preview {
//    var message: Message
//
//    NavigationStack {
//        MessageCell(message: message)
//    }
//
//}

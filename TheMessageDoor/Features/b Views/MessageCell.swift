//
//  MessageCell.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageCell: View {
    
    var k: Constants = Constants()
    @State var message: Message
    @Environment(\.colorScheme) var colorScheme
//    var user = GetCurrentUser(initialLoad: false)
    @State var isSender: Bool

    var body: some View {

        HStack {

            // Image
            Spacer()
            Spacer()
            if message.isSent {
                Image("Logo_TMD_large")
                    .resizable()
                    .frame(width: 50, height: 90)
            } else {
                Image("LogoDraftv2")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
           

            // Rectangle
            ZStack {
                Rectangle()
                    .fill(!message.isSent ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color.white)
                    .frame(width: 280, height: 100)
                    .shadow(color: message.isSent ? Color.white : Color.gray, radius: 5, x: 5, y: 5)
                    .border(Color.gray, width: 1)
                HStack {

                    VStack(alignment: .leading) {
                        Text(message.message)
                            .foregroundColor(!message.isSent ? Color.black :Color.blue)
                            .font(.caption)
                            .lineLimit(1)
                            .bold()

                        Text(isSender ? message.to : message.from)
                            .font(.body)
                            .foregroundColor(!message.isSent ? Color.black :Color.black)

                        HStack {
                            Text("Saved:")
                                .font(.caption)
                                .foregroundColor(!message.isSent ? Color.black :Color.black)
                            
                            Text(
                                message.dateCreated,
                                format: Date.FormatStyle(date: .numeric)
                                )
                                .font(.caption)
                                .foregroundColor(!message.isSent ? Color.black :Color.black)
                        }
                        
                        
                        HStack {
                            Text("Status:")
                                .font(.caption)
                                .foregroundColor(!message.isSent ? Color.black :Color.black)
                            Text(message.isSent ? "Sent" : "UNSENT")
                                .font(.caption)
                                .fontWeight(message.isSent ? .regular: .bold)
                                .foregroundColor(message.isSent ? Color.black :Color.red)
                            if message.isSent {
                                Text(message.dateSent,
                                format: Date.FormatStyle(date: .numeric))
                                    .font(.caption)
                                    .foregroundColor(Color.black)
                                Image(systemName: "paperplane")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color.blue)
                            }
                            
                        }
//                        Text(message.messageId)
//                            .font(.caption2)
//                            .foregroundColor(Color.black)

                    }
                    Spacer()

                    VStack(alignment: .trailing) {
                        Spacer()
                        if message.senderFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.bottom, 5)
                        } else {
                            Image(systemName: "heart")
                            .font(.caption)
                            .foregroundColor(message.isSent ? Color.gray : Color.gray)
                            .padding(.bottom, 5)
                        }
                          
                       
                        if message.receiverFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                                .padding(.bottom, 10)
                        } else {
                            Image(systemName: "heart")
                            .font(.caption)
                            .foregroundColor(message.isSent ? Color.gray : Color.gray)
                            .padding(.bottom, 5)
                        }
                        
                        Text(message.isSent ? message.messageStatus : "")
                            .font(.caption)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, -10)
                .frame(width: 280, height: 100)
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

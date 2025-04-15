//
//  MessageDetail.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageDetail: View {

    @StateObject private var mVM = MessageViewModel()
    @StateObject private var pVM = ProfileViewModel()
    @StateObject private var fonts = Fonts()
    @Environment(\.colorScheme) var colorScheme

    @State var message: Message
    @State var fontList: [String] = []
    @State var sender: Bool

    var body: some View {
        Text("View Message")
            .font(.system(size: 34, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.top, 10)

        ScrollView {
            VStack {
                Spacer()

                HStack {
                    Text("Sender:")
                        .foregroundColor(.blue)
                    Text(message.from)
                        .foregroundColor(.tmdText)
                }

                HStack {
                    Text("My Recipient: \(message.to)")
                        .foregroundColor(.black)
                }
                .frame(width: 350, height: 75)
                .background(Color.white)
                .border(Color.blue, width: 2)

                Toggle(
                    "Make this a favorite?",
                    isOn: sender
                        ? $mVM.currentSenderFavorite
                        : $mVM.currentReceiverFavorite
                )
                .foregroundColor(.blue)
                .padding(.bottom, 20)

                if message.isSent {
                    Text(
                        sender
                            ? "THIS MESSAGE HAS BEEN SENT"
                            : "THIS MESSAGE WAS SENT TO YOU"
                    )
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                }

                //     ShowNote()
                ZStack {
                    Rectangle()
                        .fill(Color(.yellow))
                        .frame(width: 350, height: 305)
                        .shadow(
                            color: colorScheme == .dark
                                ? Color.gray : Color.black,
                            radius: 10, x: 10, y: 10)
                    VStack(alignment: .trailing) {
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: 350, height: 20)
                        //                    Text("message")
                        if message.isSent {
                            Text(message.message)
                                .font(.custom(message.messageFont, size: 25))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.center)
                                .scrollContentBackground(.hidden)
                                .frame(width: 350, height: 190)
                                .background(Color(.yellow))
                        } else {
                            TextEditor(text: $message.message)
                                .font(.custom(message.messageFont, size: 25))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.center)
                                .scrollContentBackground(.hidden)
                                .frame(width: 350, height: 190)
                                .background(Color(.yellow))
                        }

                        Image(_: "signature no background")
                            .resizable()
                            .frame(width: 100, height: 80)
                            .scaledToFit()
                            .frame(alignment: .bottomTrailing)
                    }

                }
                .padding(.bottom, 20)

                // Message Stats
                if sender {

                    if message.isSent {
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
                                    message.messageOpenedStatus
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
                                //                            Text(message.messageDateOpened ?? "N/A",
                                //                                 format: Date.FormatStyle(date: .numeric))
                                //                                .foregroundColor(.black)
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

                if !message.isSent {
                    HStack {
                        Text("Font:")
                            .foregroundColor(.black)
                        Picker(
                            "",
                            selection: $message.messageFont
                        ) {
                            Text("").tag("")
                            ForEach(fontList, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.menu)
                            .frame(width: 225, height: 60)
                            .padding(.vertical, -15)
                            .padding(.horizontal, -10)
                    }
                    .frame(width: 350, height: 75)
                    .background(Color.white)
                    .border(Color.blue, width: 2)
                }

                if !message.isSent {
                    // Save/Update Message
                    Button(action: {
                        //                    mVM.createMessage(
                        //                        messageId: UUID().uuidString,
                        //                        from: pVM.currentUserFirstName,
                        //                        senderId: pVM.currentUserId,
                        //                        to: pVM.currentReceiverEmail,
                        //                        receiverId: pVM.currentReceiverId,
                        //                        message: mVM.currentMessage,
                        //                        dateSent: Date(),
                        //                        senderFavorite: mVM.currentSenderFavorite,
                        //                        isSent: false,
                        //                        messageFont: mVM.messageFont)

                    }) {
                        Text("Save Message")
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                    }
                }

                // Send Message
                if !message.isSent {
                    Button(action: {
                        //                    mVM.updateMessage(
                        //                        xid: mVM.selectMessage.id,
                        //                        xmessage: mVM.selectMessage.message,
                        //                        xisFavorite: mVM.selectMessage.isFavorite,
                        //                        xisSent: true,
                        //                        xmessageFont: mVM.selectMessage.messageFont)

                    }) {
                        Text("Send Message")
                            .frame(width: 200, height: 40)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                }

                // Delete Message
                Button(action: {
                    //                    mVM.updateMessage(
                    //                        xid: mVM.selectMessage.id,
                    //                        xmessage: mVM.selectMessage.message,
                    //                        xisFavorite: mVM.selectMessage.isFavorite,
                    //                        xisSent: true,
                    //                        xmessageFont: mVM.selectMessage.messageFont)

                }) {
                    Text("Delete Message")
                        .frame(width: 200, height: 40)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }

                Spacer()

            }
            .padding(.horizontal, 40)
        }

        .onAppear {
            Task {
                //                try? await pVM.loadCurrentUser()
                //                try? await mVM.getSpecificMessage(messageId: messageId)
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)
                //        mVM.messageFont = mVM.currentMessageFont

            }
        }
        //        .onChange(of: oVM.selectedReceiverEmail) {
        //
        //                do {
        //                    Task {
        //                        try await pVM.getReceiver(
        //                            email: oVM.selectedReceiverEmail)
        //                    }
        //                }
        //            }

        .alert(
            isPresented: $mVM.updateMessageSuccessful,
            content: {
                Alert(
                    title: Text("Message Created"),
                    message: Text("Your message has been saved. Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )

        .padding(.bottom, 10)
        .navigationTitle(Text(""))
    }
}

//#Preview {
//    NavigationStack {
//
//        var message: Message
//
//        MessageDetail(message: message)
//    }
//
//}

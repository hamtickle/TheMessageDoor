//
//  MessageDetail.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageDetail: View {

    @State var user: Person
    @EnvironmentObject var pVM: ProfileVM
    @StateObject var vm: MessageDetailVM = MessageDetailVM()

    @StateObject private var fonts = Fonts()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var message: Message
    @State var fontList: [String] = []
    @State var sender: Bool
    @State private var isPressedSave = false
    @State private var isPressedSend = false
    @State private var isPressedDelete = false

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
                        ? $vm.currentSenderFavorite
                        : $vm.currentReceiverFavorite
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
                        MessageStats(message: message)

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
                        vm.saveMessage(message: message)

                    }) {
                        Text("Save Message")
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                    }
                    .opacity(isPressedSave ? 0.6 : 1.0)
                    .scaleEffect(isPressedSave ? 1.1 : 1.0)
                    .pressEvents {
                        withAnimation(.easeIn(duration: 0.2)) {
                            isPressedSave = true
                        }
                    } onRelease: {
                        withAnimation {
                            isPressedSave = false
                        }
                    }
                }
                    

                // Send Message
                if !message.isSent {
                    Button(action: {
                        Task {
                            vm.sendSavedMessage(message: message)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }

                    }) {
                        Text("Send Message")
                            .frame(width: 200, height: 40)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                    .opacity(isPressedSend ? 0.6 : 1.0)
                    .scaleEffect(isPressedSend ? 1.1 : 1.0)
                    .pressEvents {
                        withAnimation(.easeIn(duration: 0.2)) {
                            isPressedSend = true
                        }
                    } onRelease: {
                        withAnimation {
                            isPressedSend = false
                        }
                    }
                }
                    

                // Delete Message
                Button(action: {
                    vm.senderDeleteMessage(message: message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                   
                }) {
                    Text("Delete Message")
                        .frame(width: 200, height: 40)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }
                .opacity(isPressedDelete ? 0.6 : 1.0)
                .scaleEffect(isPressedDelete ? 1.1 : 1.0)
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPressedDelete = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressedDelete = false
                    }
                }

                Spacer()

            }
            .padding(.horizontal, 40)
        }

        .onAppear {
            Task {
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)
            }
        }
        .onChange(of: vm.currentSenderFavorite) {
            vm.toggleSenderFavorite(message: message)
        }
        .onChange(of: vm.currentReceiverFavorite) {
            vm.toggleReceiverFavorite(message: message)
        }

        .alert(
            isPresented: $vm.updateMessageSuccessful,
            content: {
                Alert(
                    title: Text("Message Updated"),
                    message: Text("Your message has been saved. Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .alert(
            isPresented: $vm.messageDeleted,
            content: {
                Alert(
                    title: Text("Message Deleted"),
                    message: Text("Your messaged has been deleted."),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
        .alert(
            isPresented: $vm.savedSent,
            content: {
                Alert(
                    title: Text("Message Sent"),
                    message: Text("Your messaged has been sent."),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )

        .padding(.bottom, 10)
        .navigationTitle(Text(""))

    }
}

#Preview {
    NavigationStack {
        
        var message: Message = .init(messageId: "")

        MessageDetail(user: Person(userId: ""), message: message, sender: true)
    }

}

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

//
//  MessageDetail.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageDetail: View {

    @State var user: Person
    private var k: Constants = Constants()
    @ObservedObject var vm: MessageVM

    @StateObject private var fonts = Fonts()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>

    @State var message: Message
    @State var fontList: [String] = []
    @State var isSender: Bool
    @State var isFavorite: Bool = false

    @State private var isPressedSave = false
    @State private var isPressedSend = false
    @State private var isPressedDelete = false
    @Binding var reload: Bool

    init(vm: MessageVM, user: Person, message: Message, isSender: Bool,  reload: Binding<Bool>) {

        _vm = ObservedObject(wrappedValue: vm)
        _user = State(wrappedValue: user)
        _message = State(wrappedValue: message)
        _isSender = State(wrappedValue: isSender)
        _reload = reload
        
    }

    var body: some View {

// MARK: Message Header
        
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

                HStack {
                    Text("Favorite?")
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)

                    isFavorite
                        ? Image(systemName: "heart.fill")
                        .foregroundColor(isSender ? .red : .blue)
                            .padding(.bottom, 10)
                        : Image(systemName: "heart")
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                }
                .onTapGesture {
                    isFavorite.toggle()
                    isSender ? (message.senderFavorite = isFavorite) : (message.receiverFavorite = isFavorite)
                   
                    vm.toggleFavorite(message: message)
                    
                        reload = true
                    
                    
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                .font(.title)

                if message.isSent {
                    Text(
                        isSender
                        ? k.messageSent
                        : k.messageSentToYou
                    )
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                }

// MARK: Note Page
                
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
                                .font(.custom(message.messageFont, size: message.messageFontSize))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.center)
                                .scrollContentBackground(.hidden)
                                .frame(width: 350, height: 190)
                                .background(Color(.yellow))
                        } else {
                            TextEditor(text: $message.message)
                                .font(.custom(message.messageFont, size: message.messageFontSize))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.center)
                                .scrollContentBackground(.hidden)
                                .frame(width: 350, height: 190)
                                .background(Color(.yellow))
                        }

                        if k.allowSignatures {
                            Image(_: "signature no background")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .scaledToFit()
                                .frame(alignment: .bottomTrailing)
                        }
                       
                    }

                }
                .padding(.bottom, 20)

                // Message Stats
                if isSender {

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

 // MARK: Buttons
                
                if !message.isSent {
                    // Save/Update Message
                    Button(action: {
                        message.senderFavorite = isFavorite
                        vm.saveMessage(message: message)
                    
                        reload = true

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
                            reload = true
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1.0
                            ) {
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
        
// MARK: OnAppear
        
        .onDisappear {
            print( "Message Detail View disappeared \n")
        }
        .onAppear {
            print("Message Detail View appeared \n")
            Task {
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)
            }
            
            isFavorite = isSender ? message.senderFavorite : message.receiverFavorite
            
        
        }
        .task {
            if message.messageStatus == k.statusSent {
                message.messageStatus = k.statusRead
                message.messageDateOpened = Date()
                vm.saveMessage(message: message)
            }
        }
        
        .onChange(of: message.messageFont) {
            let font = message.messageFont
            message.messageFontSize = fonts.getFontSize(font: font)
            print(message.messageFontSize)
        }

        .alert(
            isPresented: $vm.updateMessageSuccessful,
            content: {
                Alert(
                    title: Text("Message Updated"),
                    message: Text(k.messageSaved),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .alert(
            isPresented: $vm.messageDeleted,
            content: {
                Alert(
                    title: Text("Message Deleted"),
                    message: Text(k.messageDeleted),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
        .alert(
            isPresented: $vm.savedSent,
            content: {
                Alert(
                    title: Text("Message Sent"),
                    message: Text(k.messageSent2),
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

        MessageDetail(
            vm: MessageVM(),
            user: Person(userId: ""),
            message: message,
            isSender: true,
            reload: .constant(true))
    }
    

}

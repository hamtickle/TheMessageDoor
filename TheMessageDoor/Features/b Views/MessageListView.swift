//
//  MessageListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/10/25.
//

import SwiftUI

struct MessageListView: View {

    private var k: Constants = Constants()
    @StateObject var user: GetCurrentUser
    @StateObject var vm: MessageVM

    @State var messageFilter = 0
    @State var myMessages = 0
    @State var isSender: Bool = true
    @State var noMessages: Bool = false
    @State var reload: Bool = false
    @State var loading: Bool = false
    @Binding var initialLoad: Bool
    

    init(initialLoad: Binding<Bool>) {
        print("mLV: Init MessageVM \n")
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: MessageVM())
        _initialLoad = initialLoad

        if reload {
            loading = true
        }

    }

    var body: some View {

        VStack(alignment: .center) {
            Text("\(user.currentUser.firstName)'s Message Door")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 30)
            if k.showIds {
                Text("ID: \(user.currentUser.userId)")
                    .font(.caption)
            }
            
            Text("Total Messages: \(vm.displayMessages.count)")

            MessagePickers(vm: vm, messageFilter: $messageFilter, myMessages: $myMessages)
            
            SearchBarView(vm: vm)
            
            // The List
            List(vm.displayMessages) { message in
                NavigationLink(
                    destination: MessageDetail(
                        vm: vm,
                        user: user.currentUser, message: message,
                        isSender: isSender, reload: $reload)
                ) {
                    HStack {
                        MessageCell(message: message, isSender: isSender)
                            .frame(width: 300)
                            //                            .padding(.vertical, 0)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .listStyle(.plain)

            .onChange(of: messageFilter) { oldValue, newValue in
                if newValue == 0 {
                        isSender = true
                        myMessages = 0
                } else {
                        isSender = false
                        myMessages = 0
                }
                Task {
                    await vm.displayMessages(messageFilter: messageFilter, myMessages: myMessages, senderId: user.currentUser.userId, senderEmail: user.currentUser.email)
                }
                
            }
            
            .onChange(of: myMessages) { oldValue, newValue in
                if newValue == 0 {
                    do {
                        vm.displayMessages = messageFilter == 0 ? vm.senderMessages : vm.receivedMessages
                        vm.sortMessagesByDate()
                        isSender = false
                    }
                } else
                if myMessages == 1 {
                    do {
                        vm.displayMessages = messageFilter == 0 ? vm.senderFavorites : vm.receivedFavorites
//                        vm.displayMessages = vm.receivedFavorites
                        vm.sortMessagesByDate()
                        isSender = false
                        
                    }
                } else if myMessages == 2 {
                    vm.displayMessages = messageFilter == 0 ? vm.senderUnsent : vm.receivedUnread
//                    vm.displayMessages = vm.receivedUnread
                    vm.sortMessagesByDate()
                    isSender = false
                } else if myMessages == 3 {
                    vm.displayMessages = vm.sentUnread
//                    vm.displayMessages = vm.receivedUnread
                    vm.sortMessagesByDate()
                    isSender = false
                }
                
            }
    
            .onDisappear {
                print("List View Disappeared \n")
            }

                        .alert(isPresented: $noMessages,
                               content: {
                            Alert(
                                title: Text("No Messages"),
                                message: Text(k.noMessages),
                                dismissButton: .cancel(Text("OK"))
                            )
                        })
        }
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .onAppear {
            print("List View Appeared \n")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                loading = false
                if vm.unReadMessages > 0 {
                    messageFilter = 1
                }
            }
            

        }
        .fullScreenCover(isPresented: $initialLoad) {
            NavigationStack {
                LoadingView(vm: vm, user: user)
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
        }
    }

}

#Preview {
    @Previewable @State var value = true
    NavigationStack {
        MessageListView(initialLoad: $value)
    }

}

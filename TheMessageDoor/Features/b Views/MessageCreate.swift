//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct CreateMessageView: View {
     
    @EnvironmentObject var pVM: ProfileVM
    @StateObject var vm: MessageCreateVM = MessageCreateVM()
    var k: Constants = Constants()
    var fonts = Fonts()

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>
    
   
    @State var fontList: [String] = []
    @State var receiverList: [String] = []
    @State var isPressed: Bool = false
    
//    @State var user: Person
    @Binding var tabSelection: Int

    var body: some View {

        Text("Create Message")
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
                    Text(pVM.currentUser.firstName)
                }
                .foregroundColor(.tmdText)

                RecipientPicker(vm: vm, user: pVM.currentUser,  receiverList: receiverList)

                Toggle("Favorite?", isOn: $vm.currentSenderFavorite)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                //     ShowNote()
                ShowNote(vm: vm)

                HStack {
                    Text("Font:")
                        .foregroundColor(.black)
                    Picker(
                        "",
                        selection: $vm.messageFont
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
                

                // Save/Update Message

                
                Button(action: {
                    vm.createMessage(
                        messageId: UUID().uuidString,
                        from: pVM.currentUser.firstName,
                        senderId: pVM.currentUser.userId,
                        to: vm.currentReceiverEmail,
                        receiverId: vm.currentReceiverId,
                        message: vm.currentMessage,
                        dateSent: Date(),
                        senderFavorite: vm.currentSenderFavorite,
                        isSent: false,
                        messageFont: vm.messageFont,
                        messageStatus: k.statusSaved,
                        messageDateOpened: Date(),
                        receiverDeleted: false,
                        receiverFavorite: false

                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        tabSelection = 0}

                }) {
                    Text("Save Message")
                        .frame(width: 200, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                      //  .border(Color.blue, width: 2)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.vertical, 5)

                }
                .opacity(isPressed ? 0.6 : 1.0)
                .scaleEffect(isPressed ? 1.1 : 1.0)
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressed = false
                    }
                }
                
                // Send Message

                Button(action: {
                    vm.createMessage(
                        messageId: UUID().uuidString,
                        from: pVM.currentUser.firstName,
                        senderId: pVM.currentUser.userId,
                        to: vm.currentReceiverEmail,
                        receiverId: vm.currentReceiverId,
                        message: vm.currentMessage,
                        dateSent: Date(),
                        senderFavorite: vm.currentSenderFavorite,
                        isSent: true,
                        messageFont: vm.messageFont,
                        messageStatus: k.statusSent,
                        messageDateOpened: Date(),
                        receiverDeleted: false,
                        receiverFavorite: false
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        tabSelection = 0}
                }) {
                    Text("Send Message")
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }
                .opacity(isPressed ? 0.6 : 1.0)
                .scaleEffect(isPressed ? 1.1 : 1.0)
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressed = false
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
                vm.messageFont = pVM.currentUser.myFont

            }
        }
        .onChange(of: vm.selectedReceiverEmail) {

            vm.getReceiverInfo(email: vm.selectedReceiverEmail)
            
        }
        .alert(
            isPresented: $vm.updateMessageSuccessful,
            content: {
                Alert(
                    title: Text("Message Created"),
                    message: Text("Your message has been saved. Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .alert(isPresented: $vm.noOrders,
               content: {
            Alert(
                title: Text("No Active Orders"),
                message: Text("You do not have any ACTIVE orders.  \n Please create an order so you can send messages."),
                dismissButton: .cancel(Text("OK"))
            )
        })
        .onTapGesture {
            self.endTextEditing()
        }

    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil,
            for: nil)
    }
}

//#Preview {
//
//    NavigationStack {
//        CreateMessageView(
//            user: Person(userId: ""),
//            vm: MessageCreateVM(),
//            tabSelection: .constant(1))
//    }
//
//}

struct ShowNote: View {

    @StateObject var vm: MessageCreateVM
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {

            Rectangle()
                .fill(Color(.yellow))
                .frame(width: 350, height: 305)
                .shadow(
                    color: colorScheme == .dark ? Color.gray : Color.black,
                    radius: 10, x: 10, y: 10)

            VStack(alignment: .trailing) {
                Rectangle()
                    .fill(Color(.yellow))
                    .frame(width: 350, height: 20)
                //                    Text("message")
                TextEditor(text: $vm.currentMessage)
                    .font(.custom(vm.messageFont, size: 25))
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                    .scrollContentBackground(.hidden)
                    .frame(width: 350, height: 190)
                    .background(Color(.yellow))
                Image(_: "signature no background")
                    .resizable()
                    .frame(width: 100, height: 80)
                    .scaledToFit()
                    .frame(alignment: .bottomTrailing)
            }

        }
        .padding(.bottom, 20)
    }
}

struct CreateMessageButtonsView: View {
 
    @EnvironmentObject var pVM: ProfileVM
    @StateObject var vm: MessageCreateVM
    private var k: Constants = Constants()

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>
    
    @State var user: Person
    @State var updateMessageSent: Bool
   

    var body: some View {
        Button(action: {
            vm.createMessage(
                messageId: UUID().uuidString,
                from: user.firstName,
                senderId: user.userId,
                to: vm.currentReceiverEmail,
                receiverId: vm.currentReceiverId,
                message: vm.currentMessage,
                dateSent: Date(),
                senderFavorite: vm.currentSenderFavorite,
                isSent: false,
                messageFont: vm.messageFont,
                messageStatus: k.statusSaved,
                messageDateOpened: Date(),
                receiverDeleted: false,
                receiverFavorite: false

            )
            updateMessageSent = true

        }) {
            Text("Save Message")
                .frame(width: 200, height: 40)
                .background(Color.white)
                .foregroundColor(.black)
                .border(Color.blue, width: 2)
                .padding(.horizontal)
                .cornerRadius(10)
                .padding(.vertical, 5)

        }
        // Send Message

        Button(action: {
            vm.createMessage(
                messageId: UUID().uuidString,
                from: user.firstName,
                senderId: user.userId,
                to: vm.currentReceiverEmail,
                receiverId: vm.currentReceiverId,
                message: vm.currentMessage,
                dateSent: Date(),
                senderFavorite: vm.currentSenderFavorite,
                isSent: true,
                messageFont: vm.messageFont,
                messageStatus: k.statusSent,
                messageDateOpened: Date(),
                receiverDeleted: false,
                receiverFavorite: false
            )
            updateMessageSent = true

        }) {
            Text("Send Message")
                .frame(width: 200, height: 40)
                .background(Color.blue)
                .foregroundColor(.white)
                .padding(.horizontal)
                .cornerRadius(10)
                .padding(.vertical, 5)
        }

    }
}

struct RecipientPicker: View {
    
    @EnvironmentObject var pVM: ProfileVM
    @StateObject var vm: MessageCreateVM

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
    Binding<PresentationMode>
    
    @State var user: Person
    @State var receiverList: [String]
    
    
    var body: some View {
        HStack {
            Text("My Recipients:")
                .foregroundColor(.black)
            
            Picker(
                "",
                selection: $vm.selectedReceiverEmail
            ) {
                Text("").tag("")
                ForEach(receiverList, id: \.self) {
                    Text($0)
                }
       //         .onAppear{oVM.selectedReceiverEmail = receiverList[0]}
            }.pickerStyle(.menu)
                .frame(width: 225, height: 60)
                .padding(.vertical, -15)
                .padding(.horizontal, -10)
        }
        .frame(width: 350, height: 75)
        .background(Color.white)
        .border(Color.blue, width: 2)
        .onAppear {
            Task {
                try? await vm.getReceivers(senderId: pVM.currentUser.userId)
                receiverList.removeAll()
                receiverList.append(contentsOf: vm.receiverList)
            }
        }
        .onChange(of: vm.selectedReceiverEmail) {
            
            vm.getReceiverInfo(email: vm.selectedReceiverEmail)

        }
        
    }
}

//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct CreateMessageView: View {

    @StateObject var user: GetCurrentUser
    @StateObject var vm: MessageCreateVM
    var k: Constants = Constants()
    var fonts = Fonts()
    @State var fontSize: CGFloat = 25

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>

    @State var fontList: [String] = []

    @State var receiverList: [String] = []
    @State var isPressed: Bool = false
    @State var myFavorite: Bool = false

    @Binding var tabSelection: Int

    init(tabSelection: Binding<Int>) {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: MessageCreateVM())
        _tabSelection = tabSelection
    }

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
                    Text(user.currentUser.firstName)
                }
                .foregroundColor(.tmdText)

                RecipientPicker(vm: vm)

                HStack {
                    Text("Favorite?")
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)

                    myFavorite
                        ? Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                        : Image(systemName: "heart")
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                }
                .onTapGesture { myFavorite.toggle() }
                .padding(.bottom, 10)
                .padding(.top, 10)
                .font(.title)

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
                        from: user.currentUser.firstName,
                        senderId: user.currentUser.userId,
                        to: vm.currentReceiverEmail,
                        message: vm.currentMessage,
                        senderFavorite: myFavorite,
                        isSent: false,
                        messageFont: vm.messageFont,
                        messageFontSize: vm.fontSize,
                        messageStatus: k.statusSaved
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        tabSelection = 0
                    }

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
                        from: user.currentUser.firstName,
                        senderId: user.currentUser.userId,
                        to: vm.selectedReceiverEmail,
                        message: vm.currentMessage,
                        senderFavorite: myFavorite,
                        isSent: true,
                        messageFont: vm.messageFont,
                        messageFontSize: vm.fontSize,
                        messageStatus: k.statusSent
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        tabSelection = 0
                    }
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
                vm.messageFont = user.currentUser.myFont

            }
        }
        .onChange(of: vm.selectedReceiverEmail) {

            vm.getReceiverInfo(email: vm.selectedReceiverEmail)

        }
        .onChange(of: vm.messageFont) {
            let font = vm.messageFont
            vm.fontSize = fonts.getFontSize(font: font)
            print(vm.fontSize)
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
        .alert(
            isPresented: $vm.noOrders,
            content: {
                Alert(
                    title: Text("No Active Orders"),
                    message: Text(
                        "You do not have any ACTIVE orders.  \n Please create an order so you can send messages."
                    ),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
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

#Preview {

    NavigationStack {
        CreateMessageView(
            tabSelection: .constant(1))
    }

}

//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct MessageView: View {
    @StateObject var pVM : ProfileViewModel
    @StateObject var mVM : MessageViewModel
    @StateObject var oVM : OrderViewModel
    
    @StateObject private var fonts = Fonts()
    @Environment(\.colorScheme) var colorScheme
    
//    @Binding var isFavorite: Bool
    @State var fontList: [String] = []
    
    @State var receiverList: [String] = []

    var body: some View {
        
        Text("Create Message")
            .font(.system(size: 34, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.top, 10)
        
        ScrollView {
            VStack  {
                Spacer()

                
                
                HStack{
                    Text("Sender:")
                        .foregroundColor(.blue)
                    Text(pVM.currentUserFirstName) }
                        .foregroundColor(.tmdText)
                    
                HStack {
                    Text("My Recipients:")
                        .foregroundColor(.black)

                    Picker(
                        "",
                        selection: $oVM.selectedReceiverEmail
                    ) {
                        Text("").tag("")
                        ForEach(receiverList, id: \.self) {
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
                    
                Toggle("Favorite?", isOn: $mVM.currentSenderFavorite)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
                
           //     ShowNote()
                ZStack{
                    
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: 350, height: 305)
                            .shadow(color: colorScheme == .dark ? Color.gray : Color.black,
                                    radius: 10, x: 10, y: 10 )
                   
                    
                    VStack(alignment: .trailing)  {
                        Rectangle()
                            .fill(Color(.yellow))
                            .frame(width: 350, height: 20)
    //                    Text("message")
                        TextEditor(text: $mVM.currentMessage)
                            .font(.custom(mVM.messageFont, size: 25))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                            .scrollContentBackground(.hidden)
                            .frame(width: 350, height: 190)
                            .background(Color(.yellow))
                        Image(_:"signature no background")
                            .resizable( )
                            .frame(width: 100, height: 80)
                            .scaledToFit( )
                            .frame(alignment:.bottomTrailing)
                    }
                    
                }
                .padding(.bottom, 20)
                
                HStack {
                    Text("Font:")
                        .foregroundColor(.black)
                    Picker("",
                           selection: $mVM.messageFont)
                    {
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
                .onAppear {
          //          mVM.messageFont = pVM.myFont
                }
                
                // Save/Update Message
                Button(action: {
                        mVM.createMessage(
                            messageId: UUID().uuidString,
                            from: pVM.currentUserFirstName,
                            senderId: pVM.currentUserId,
                            to: pVM.currentReceiverEmail,
                            receiverId: pVM.currentReceiverId,
                            message: mVM.currentMessage,
                            dateSent: Date(),
                            senderFavorite: mVM.currentSenderFavorite,
                            isSent: false,
                            messageFont: mVM.messageFont)
                                                
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
                
          //       Send Message

                    Button(action: {
                    mVM.createMessage(
                        messageId: UUID().uuidString,
                        from: pVM.currentUserFirstName,
                        senderId: pVM.currentUserId,
                        to: pVM.currentReceiverEmail,
                        receiverId: pVM.currentReceiverId,
                        message: mVM.currentMessage,
                        dateSent: Date(),
                        senderFavorite: mVM.currentSenderFavorite,
                        isSent: true,
                        messageFont: mVM.messageFont)
                        
                    }) {
                        Text("Send Message")
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
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
   //             try? await pVM.loadCurrentUser()
                try? await oVM.getReceivers(senderId: pVM.currentUserId)
                receiverList.removeAll()
                receiverList.append(contentsOf: oVM.receiverList)
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)
                mVM.messageFont = pVM.currentUserMyFont

            }
        }
        .onChange(of: oVM.selectedReceiverEmail) {

                do {
                    Task {
                        try await pVM.getReceiver(
                            email: oVM.selectedReceiverEmail)
                    }
                }
            }
        
        .alert(
            isPresented: $mVM.updateMessageSuccessful,
            content: {
                Alert(
                    title: Text("Message Created"),
                    message: Text("Your message has been saved. Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .onTapGesture {
            self.endTextEditing()
        }
//        .padding(.bottom, 100)
        .navigationTitle(Text("Create Message"))
        

    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {

    NavigationStack {
        MessageView(pVM: ProfileViewModel(), mVM: MessageViewModel(), oVM: OrderViewModel())
    }
    

}

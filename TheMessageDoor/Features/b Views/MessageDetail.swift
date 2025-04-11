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
    
    @State var messageId: String
    @State var fontList: [String] = []
 
    var body: some View {
        VStack  {
            Spacer()
            
            Text("View Message")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, -20)
                .padding(.top, 30)
            
            HStack{
                Text("Sender:")
                    .foregroundColor(.blue)
                Text(mVM.currentFrom)
                    .foregroundColor(.tmdText)
            }
            
            HStack {
                Text("My Recipient: \(mVM.currentTo)")
                    .foregroundColor(.black)
            }
            .frame(width: 350, height: 75)
            .background(Color.white)
            .border(Color.blue, width: 2)
            
            Toggle("Favorite?", isOn: $mVM.currentSenderFavorite)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            //     ShowNote()
            ZStack{
                Rectangle()
                    .fill(Color(.yellow))
                    .frame(width: 350, height: 305)
                    .shadow(color: Color.black, radius: 10, x: 10, y: 10 )
                VStack(alignment: .trailing)  {
                    Rectangle()
                        .fill(Color(.yellow))
                        .frame(width: 300, height: 20)
                    //                    Text("message")
                    TextEditor(text: $mVM.currentMessage)
                        .font(.custom(mVM.currentMessageFont, size: 25))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .scrollContentBackground(.hidden)
                        .frame(width: 310, height: 190)
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
                       selection: $mVM.currentMessageFont)
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
                
            }
            
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
            
            // Send Message
            if mVM.currentIsSent {}
            else {
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
                
                
                Spacer()
                
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            Task {
                try? await pVM.loadCurrentUser()
                try? await mVM.getSpecificMessage(messageId: messageId)
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

        .padding(.bottom, 100)
        .navigationTitle(Text(""))
    }
}

#Preview {
    NavigationStack {
        
        var message: Message
        
        MessageDetail(messageId: "aaa")
    }
    
}

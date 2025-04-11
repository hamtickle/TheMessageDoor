//
//  MessageViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/9/25.
//

import Foundation

@MainActor
class MessageViewModel: ObservableObject {
    
    @Published private(set) var message: Message? = nil
    
    @Published var currentFrom: String = ""
    @Published var currentSenderId: String = ""
    @Published var currentTo: String = ""
    @Published var currentReceiverId: String = ""
    @Published var currentMessage: String = ""
    @Published var currentDateCreated: Date = Date.now
    @Published var currentSenderFavorite: Bool = false
    
    @Published var isNewMessage: Bool = false
    @Published var mySentMessages: Int = 0
    @Published var myFavMessages: Int = 0
    @Published var receiverFavMessages: Int = 0
    
    @Published var displayMessages: [Message] = []
    
    @Published var messageFont: String = ""
    
    @Published var updateMessageSuccessful: Bool = false
    
//    func updateMessage(
//        messageId: String,
//        from: String,
//        senderId: String,
//        to: String,
//        receiverId: String,
//        message: String,
//        dateSent: Date,
//        senderFavorite: Bool,
//        isSent: Bool,
//        messageFont: String,
//        messageOpenedStatus: String,
//        messageDateOpened: Date,
//        receiverFavorite: Bool,
//        receiverDeleted: Bool) {
//   
//   //     guard let message else { return }
//        
//        let updatedMessage = Message(
//            messageId: messageId,
//            from: from,
//            senderId: senderId,
//            to: to,
//            receiverId: receiverId,
//            message: message,
//            dateSent: dateSent,
//            senderFavorite: senderFavorite,
//            isSent: isSent,
//            messageFont: messageFont,
//            messageOpenedStatus: messageOpenedStatus,
//            messageDateOpened: messageDateOpened,
//            receiverFavorite: receiverFavorite,
//            receiverDeleted: receiverDeleted)
//        Task {
//            try await MessageManager.shared.updateMessage(message: updatedMessage)
//    //        self.user = try await messageManager.shared.getMessage(messageId: message.messageId)
//            updateMessageSuccessful.toggle()
//        }
//    }
    
    func createMessage(
        messageId: String,
        from: String,
        senderId: String,
        to: String,
        receiverId: String,
        message: String,
        dateSent: Date,
        senderFavorite: Bool,
        isSent: Bool,
        messageFont: String)
    {
   
   //     guard let message else { return }
        
        let updatedMessage = Message(
            messageId: UUID().uuidString,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: Date(),
            isSent: isSent,
            dateSent: dateSent
            )
        Task {
            try await MessageManager.shared.updateMessage(message: updatedMessage)
    //        self.user = try await messageManager.shared.getMessage(messageId: message.messageId)
            updateMessageSuccessful.toggle()
        }
    }
    
}

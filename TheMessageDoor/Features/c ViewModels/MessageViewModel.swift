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
    @Published var currentTo: String = ""
    @Published var currentMessage: String = ""
    @Published var currentDateCreated: Date = Date.now
    @Published var currentDateSent: Date = Date.now
    @Published var currentDateOpened: Date = Date.now
    @Published var currentSenderFavorite: Bool = false
    @Published var currentReceiverFavorite: Bool = false
    @Published var currentIsSent : Bool = false
    @Published var currentMessageFont: String = ""
    @Published var currentOpenedStatus: String = ""
    @Published var currentReceiverDeleted: Bool = false
    
    @Published var isNewMessage: Bool = false
    @Published var myTotalMessages: Int = 0
    @Published var mySentMessages: Int = 0
    @Published var myFavMessages: Int = 0
    @Published var receiverFavMessages: Int = 0
    
    @Published var displayMessages: [Message] = []
    @Published var specificMessage: Message? = nil
    @Published var selectMessage: Message? = nil
    
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
    
    func fetchSenderMessages(senderId: String) async  {
        
        let displayMessges = try? await MessageManager.shared.getMessages(senderId: senderId)
        self.displayMessages = displayMessges ?? []
        
        buildSenderStats()
    }
    
    func buildSenderStats() {
        myTotalMessages = displayMessages.count
        mySentMessages = displayMessages.filter({ $0.isSent == true }).count
        myFavMessages = displayMessages.filter({ $0.senderFavorite == true }).count
        receiverFavMessages = displayMessages.filter({ $0.receiverFavorite == true }).count
        
        self.myTotalMessages = myTotalMessages
        self.myFavMessages = myFavMessages
        self.mySentMessages = mySentMessages
        self.receiverFavMessages = receiverFavMessages
    }
    
    func getSpecificMessage(messageId: String) async throws {
        
        specificMessage = try await MessageManager.shared.fetchSpecificMessage(messageId: messageId)
        
        // unwrap array values
   
        self.currentFrom = specificMessage?.from ?? ""
        self.currentTo = specificMessage?.to ?? ""
        self.currentMessage = specificMessage?.message ?? ""
        self.currentDateSent = specificMessage?.dateSent ?? Date()
        self.currentSenderFavorite = specificMessage?.senderFavorite ?? false
        self.currentIsSent = specificMessage?.isSent ?? false
        self.currentMessageFont = specificMessage?.messageFont ?? ""
        self.currentOpenedStatus = specificMessage?.messageOpenedStatus ?? ""
        self.currentDateOpened = specificMessage?.messageDateOpened ?? Date()
        self.currentReceiverFavorite = specificMessage?.receiverFavorite ?? false
        self.currentReceiverDeleted = specificMessage?.receiverDeleted ?? false
    }
    
}

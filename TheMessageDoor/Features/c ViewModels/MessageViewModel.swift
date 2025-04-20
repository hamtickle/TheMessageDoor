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
    @Published var messageDeleted: Bool = false
    @Published var savedSent: Bool = false
    
    init () {
//        do {
//            Task {
//                await fetchSenderMessages(senderId: "")
//            }
//        }
    }
    
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
        messageFont: String,
        messageOpenedStatus: String,
        messageDateOpened: Date,
        receiverDeleted: Bool,
        receiverFavorite: Bool
    )
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
            dateSent: dateSent,
            messageOpenedStatus: "",
            messageDateOpened: Date(),
            receiverFavorite: false,
            receiverDeleted: false
    
            )
        Task {
            try await MessageManager.shared.updateMessage(message: updatedMessage)
    //        self.user = try await messageManager.shared.getMessage(messageId: message.messageId)
            updateMessageSuccessful.toggle()
            currentMessage = ""
        }
        
    }
    
    func fetchReceiverMessages(receiverId: String) async  {
        
        let displayMessges = try? await MessageManager.shared.getReceiverMessages(receiverId: receiverId)
   
        self.displayMessages = displayMessges ?? []
        sortMessagesByDate()
        
        buildSenderStats()
    }
    
    func fetchSenderMessages(senderId: String) async {
        
        let displayMessages = try? await MessageManager.shared.getMessages(senderId: senderId)
   
        self.displayMessages = displayMessages ?? []
        sortMessagesByDate()
        
        buildSenderStats()
        
   
    }
    
    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
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
    
    func sendSavedMessage(message: Message) {
        let updatedMessage = message.sendSavedMessage()
        
        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(message: updatedMessage)
                savedSent = true
                await fetchSenderMessages(senderId: message.messageId)
            } catch  {
                print("Could not send message \(error.localizedDescription)")
            }
        }
        
      
    }
    
    func toggleSenderFavorite(message: Message) {
        let updatedMessage = message.toggleSenderFavorite()
        
        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(message: updatedMessage)
            } catch  {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }
        
    }
    
    func toggleReceiverFavorite(message: Message) {
        let updatedMessage = message.toggleReceiverFavorite()
        
        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(message: updatedMessage)
            } catch  {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }
        
    }
    
    func receiverDeleteMessage(message: Message) {
        let updatedMessage = message.receiverDeleteMessage()
        
        Task {
            do {
                    _ = try await MessageManager.shared.updateMessage(message: updatedMessage)
            } catch  {
                print("Could not delete message \(error.localizedDescription)")
            }
        }
    
    }
    
    func senderDeleteMessage(message: Message) {
                
        Task {
            do {
                let thisSender = message.senderId
                try await MessageManager.shared.deleteMessage(messageId: message.messageId)
                messageDeleted = true
                await fetchSenderMessages(senderId: thisSender)
            } catch  {
                print("Could not delete message \(error.localizedDescription)")
                messageDeleted = false
            }
        }
    
    }
    
    func saveMessage(message: Message) {
        let updatedMessage = message.saveMessage()
        
        Task {
            do {
                    _ = try await MessageManager.shared.updateMessage(message: updatedMessage)
            } catch  {
                print("Could not delete message \(error.localizedDescription)")
            }
        }
    
    }
    
}

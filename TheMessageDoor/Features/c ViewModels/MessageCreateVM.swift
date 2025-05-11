//
//  MessageCreateVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class MessageCreateVM: ObservableObject {
    
    @Published private(set) var message: Message? = nil
    var pVM: ProfileVM = ProfileVM()
    private var mVM: MessageListVM = MessageListVM()
    private var rm: ReceiverManager = ReceiverManager()
    private var k: Constants = Constants()
    
//    @Published var currentReceiver: Profile? = nil
    @Published var receiverList: [String] = []
    @Published var selectedReceiverEmail: String = ""
    @Published var currentReceiverId: String = ""
    @Published var currentReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""
    
    @Published var currentMessage: String = ""
    @Published var currentSenderFavorite: Bool = false
    
    @Published var displayMessages: [Message] = []
    @Published var messageFont: String = ""
    
    @Published var updateMessageSuccessful: Bool = false
    @Published var messageDeleted: Bool = false
    @Published var savedSent: Bool = false
    @Published var noOrders: Bool = false
    
    init () {
    }
    
    func createMessage(
        messageId: String, from: String, senderId: String, to: String, receiverId: String, message: String, dateSent: Date, senderFavorite: Bool, isSent: Bool, messageFont: String, messageStatus: String, messageDateOpened: Date, receiverDeleted: Bool, receiverFavorite: Bool
    )
    {  //     guard let message else { return }
        let updatedMessage = Message(
            messageId: UUID().uuidString,from: from,senderId: senderId,to: to, receiverId: receiverId, message: message,messageFont: messageFont,senderFavorite: senderFavorite,dateCreated: Date(),isSent: isSent,dateSent: dateSent, messageStatus: messageStatus, messageDateOpened: Date(),receiverFavorite: false,receiverDeleted: false, lastUpdated: Date()
            )
        Task {
            try await MessageManager.shared.updateMessage(message: updatedMessage)
            updateMessageSuccessful.toggle()
        // update UserDefaults
//            pVM.updateSentMessageCount()
//            pVM.updateTotalMessageCount()
//            if senderFavorite {
//                pVM.updateMyFavoritesCount()
//            }
            
            currentMessage = ""
        }
    }
    
    
    func fetchSenderMessages(senderId: String) async {
        await mVM.fetchSenderMessages(senderId: senderId)
    }
    
    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
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
   //             user.?.incrementTotalMessagesCreated()
                
            } catch  {
                print("Could not delete message \(error.localizedDescription)")
            }
        }
    
    }
    
    
    func getReceivers(senderId: String) async throws {
        receiverList = try await rm.getReceivers(senderId: senderId)
        
        if receiverList.isEmpty {
            noOrders = true
        } else {
            getReceiverInfo(email: receiverList[0])
        }
    }
    
    
    func getReceiverInfo(email: String) {
        var First: String = ""
        var Last: String = ""
        var Id: String = ""
        (First, Last, Id) = rm.getReceiverInfo(email: email)
        
        self.currentReceiverId = Id
        self.currentReceiverFirstName = First
        self.currentReceiverLastName = Last
        self.currentReceiverEmail = email
    }
    
    
     
        
    
    
}

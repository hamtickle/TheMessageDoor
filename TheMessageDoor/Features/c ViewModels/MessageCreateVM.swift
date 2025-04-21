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
    private var mVM: MessageListVM = MessageListVM()
    private var rm: ReceiverManager = ReceiverManager()
    @Published var currentReceiver: Profile? = nil
    
    @Published var receiverList: [String] = []
    @Published var selectedReceiverEmail: String = ""
    
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
    @Published var currentReceiverId: String = ""
    @Published var currentReceiverFirst: String = ""
    @Published var currentReceiverLast: String = ""
    @Published var currentReceiverEmail: String = ""
    
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
            updateMessageSuccessful.toggle()
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
            } catch  {
                print("Could not delete message \(error.localizedDescription)")
            }
        }
    
    }
    
//    func getReceivers(senderId: String) async throws{
//        let result = try await OrderManager.shared.getReceivers(senderId: senderId)
//        
//        // remove duplicates from receiverlist
//        receiverList = result.unique()
//        sortReceivers()
//        print (receiverList)
//    }
//    
//    func sortReceivers() {
//        receiverList.sort { (email1, email2) -> Bool in
//            return email1 < email2
//        }
//    }
    
    func getReceivers(senderId: String) async throws {
        try await rm.getReceivers(senderId: senderId)
    }
    
    func getReceiver(email: String) async throws {
        do {
            currentReceiver = try await UserManager.shared.getUserWithEmail(
                email: email)

            currentReceiverId = self.currentReceiver?.userId ?? ""
            currentReceiverFirst = self.currentReceiver?.firstName ?? ""
            currentReceiverLast = self.currentReceiver?.lastName ?? ""
            currentReceiverEmail = self.currentReceiver?.email ?? ""
        } catch {
            print("no receiver with email: \(email) found")

        }
    }
    
}

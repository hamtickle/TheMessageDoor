//
//  MessageListVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class MessageListVM: ObservableObject {
    
    @Published private(set) var message: Message? = nil
    
    @Published var reloadList: Bool = false
    
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
    
    
}

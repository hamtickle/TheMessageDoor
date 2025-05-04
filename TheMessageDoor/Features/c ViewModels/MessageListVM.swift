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

//    @Published var myTotalMessages: Int = 0
//    @Published var mySentMessages: Int = 0
//    @Published var myFavMessages: Int = 0
//    @Published var receiverFavMessages: Int = 0

    @Published var displayMessages: [Message] = []

    init () {
    }
    
    func fetchReceiverMessages(receiverId: String) async  {
        print("\n getting received messages for \(receiverId) \n")
        let displayMessges = try? await MessageManager.shared.getReceiverMessages(receiverId: receiverId)
   
        self.displayMessages = displayMessges ?? []
        sortMessagesByDate()
        
//        buildSenderStats()
    }
    
    func fetchSenderMessages(senderId: String) async {
        print("\n getting sender's messages for \(senderId) \n")
        let displayMessages = try? await MessageManager.shared.getMessages(senderId: senderId)
   
        self.displayMessages = displayMessages ?? []
        sortMessagesByDate()
        
//        buildSenderStats()
        
   
    }
    
    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
    }
    
//    func buildSenderStats() {
//        currentUser.totalMessagesCreated = displayMessages.count
//        mySentMessages = displayMessages.filter({ $0.isSent == true }).count
//        myFavMessages = displayMessages.filter({ $0.senderFavorite == true }).count
//        receiverFavMessages = displayMessages.filter({ $0.receiverFavorite == true }).count
//        
//        self.myTotalMessages = myTotalMessages
//        self.myFavMessages = myFavMessages
//        self.mySentMessages = mySentMessages
//        self.receiverFavMessages = receiverFavMessages
//        
//    }
    
    func getUserID() -> String {
        guard
            let data = UserDefaults.standard.data(forKey: "userId"),
            case let userId = try? JSONDecoder().decode(String.self, from: data)
        else { return ""}
        return userId!
    }
}

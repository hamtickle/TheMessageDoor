//
//  MessageModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import Foundation

class Message: Codable, Identifiable, Hashable, ObservableObject {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId && lhs.from == rhs.from
            && lhs.to == rhs.to && lhs.message == rhs.message
            && lhs.dateSent == rhs.dateSent
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(message)
        hasher.combine(dateSent)

    }
    var messageId: String
    var from: String
    var senderId: String
    var to: String
    var receiverId: String
    var message: String
    var messageFont: String
    var senderFavorite: Bool
    var dateCreated: Date
    var isSent: Bool
    var dateSent: Date

    var messageOpenedStatus: String
    var messageDateOpened: Date?
    var receiverFavorite: Bool
    var receiverDeleted: Bool

    init(
        messageId: String, from: String, senderId: String, to: String, receiverId: String,
        message: String, messageFont: String, senderFavorite: Bool, dateCreated: Date, isSent: Bool, dateSent: Date
    ) {
        self.messageId = UUID().uuidString
        self.from = from
        self.senderId = senderId
        self.to = to
        self.receiverId = receiverId
        self.message = message
        self.messageFont = messageFont
        self.senderFavorite = senderFavorite
        self.dateCreated = dateCreated
        self.isSent = isSent
        self.dateSent = dateSent

        self.messageOpenedStatus = ""
        self.messageDateOpened = nil
        self.receiverFavorite = false
        self.receiverDeleted = false

    }
    
    init(messageId: String)
    {
        self.messageId = messageId
        self.from = ""
        self.senderId = ""
        self.to = ""
        self.receiverId = ""
        self.message = ""
        self.messageFont = ""
        self.senderFavorite = false
        self.dateCreated = Date()
        self.isSent = false
        self.dateSent = Date()

        self.messageOpenedStatus = ""
        self.messageDateOpened = Date()
        self.receiverFavorite = false
        self.receiverDeleted = false
        
    }
}

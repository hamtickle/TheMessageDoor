//
//  MessageModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import Foundation

struct Message: Codable, Identifiable, Hashable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId && lhs.from == rhs.from
            && lhs.to == rhs.to && lhs.message == rhs.message
            && lhs.dateSent == rhs.dateSent
    }
    
//    private var k: Constants = Constants()

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

    var messageStatus: String
    var messageDateOpened: Date?
    var receiverFavorite: Bool
    var receiverDeleted: Bool
    
    var lastUpdated: Date

    var id: String { messageId }

    init(
        messageId: String,
        from: String,
        senderId: String,
        to: String,
        receiverId: String,
        message: String,
        messageFont: String,
        senderFavorite: Bool,
        dateCreated: Date,
        isSent: Bool,
        dateSent: Date,
        messageStatus: String,
        messageDateOpened: Date?,
        receiverFavorite: Bool,
        receiverDeleted: Bool,
        lastUpdated: Date

    ) {
        self.messageId = messageId
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

        self.messageStatus = messageStatus
        self.messageDateOpened = nil
        self.receiverFavorite = false
        self.receiverDeleted = false
        self.lastUpdated = Date()

    }
    
    init(
        messageId: String
//        from: String,
//        senderId: String,
//        to: String,
//        receiverId: String,
//        message: String,
//        messageFont: String,
//        senderFavorite: Bool,
//        dateCreated: Date,
//        isSent: Bool,
//        dateSent: Date,
//        messageOpenedStatus: String,
//        messageDateOpened: Date?,
//        receiverFavorite: Bool,
//        receiverDeleted: Bool

    ) {
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

        self.messageStatus = ""
        self.messageDateOpened = nil
        self.receiverFavorite = false
        self.receiverDeleted = false
        
        self.lastUpdated = Date()

    }

    // Update  Sent status
    func sendSavedMessage() -> Message {

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: dateCreated,
            isSent: true,
            dateSent: Date(),
            messageStatus: messageStatus,
            messageDateOpened: messageDateOpened,
            receiverFavorite: receiverFavorite,
            receiverDeleted: receiverDeleted,
            lastUpdated: Date()
        )
    }

    // Update Sender Favorite status
    func toggleSenderFavorite() -> Message {
        let currentValue = senderFavorite

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: !currentValue,
            dateCreated: dateCreated,
            isSent: isSent,
            dateSent: dateSent,
            messageStatus: messageStatus,
            messageDateOpened: messageDateOpened,
            receiverFavorite: receiverFavorite,
            receiverDeleted: receiverDeleted,
            lastUpdated: Date()
        )
    }

    // Update Receiver Favorite status
    func toggleReceiverFavorite() -> Message {
        let currentValue = receiverFavorite

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: dateCreated,
            isSent: isSent,
            dateSent: dateSent,
            messageStatus: messageStatus,
            messageDateOpened: messageDateOpened,
            receiverFavorite: !currentValue,
            receiverDeleted: receiverDeleted,
            lastUpdated: Date()
        )
    }

    // Update Opened Status
    func updateOpenedStatus() -> Message {

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: dateCreated,
            isSent: isSent,
            dateSent: dateSent,
            messageStatus: "Read",
            messageDateOpened: Date(),
            receiverFavorite: receiverFavorite,
            receiverDeleted: receiverDeleted,
            lastUpdated: Date()
        )
    }

    func receiverDeleteMessage() -> Message {

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: dateCreated,
            isSent: isSent,
            dateSent: dateSent,
            messageStatus: messageStatus,
            messageDateOpened: messageDateOpened,
            receiverFavorite: receiverFavorite,
            receiverDeleted: true,
            lastUpdated: Date()
        )
    }

    // Save message if already created
    func saveMessage() -> Message {

        return Message(
            messageId: messageId,
            from: from,
            senderId: senderId,
            to: to,
            receiverId: receiverId,
            message: message,
            messageFont: messageFont,
            senderFavorite: senderFavorite,
            dateCreated: dateCreated,
            isSent: isSent,
            dateSent: dateSent,
            messageStatus: messageStatus,
            messageDateOpened: messageDateOpened,
            receiverFavorite: receiverFavorite,
            receiverDeleted: receiverDeleted,
            lastUpdated:     Date()
        )
    }

}

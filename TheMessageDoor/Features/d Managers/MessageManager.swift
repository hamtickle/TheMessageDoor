//
//  MessageManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/9/25.
//

import FirebaseFirestore
import Foundation

@MainActor
final class MessageManager {
    
    static let shared = MessageManager()
    private var k: Constants = Constants()
    
    private init() {}
    
    private let messageCollection = Firestore.firestore().collection("messages")
    
    private func messageDocument(messageId: String) -> DocumentReference {
        return messageCollection.document(messageId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func updateMessage(message: Message) async throws {
        try messageDocument(messageId: message.messageId).setData(
            from: message, merge: true, encoder: encoder)
//        print("MM: Message Updated \n")
//        print("MM: \(message) \n")
    }
    
    func getReceiverMessages(to: String) async throws -> [Message] {
        var messageList: [Message] = []
        let query = messageCollection.whereField("to", isEqualTo: to)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents  {
                let message = try document.data(as: Message.self, decoder: decoder)
                if message.messageStatus  == k.statusSaved {
                    // ignore the message
                } else {
                    messageList.append(message)
                }
            }
        }
        return messageList
    }
    
    func getMessages(senderId: String) async throws -> [Message] {
        var messageList: [Message] = []
        let query = messageCollection.whereField("sender_id", isEqualTo: senderId)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents  {
                do {
                    let message = try document.data(as: Message.self, decoder: decoder)
                    messageList.append(message)
                } catch  {
                    print("error decoding message" )
                }
                
            }
        }
        return messageList
    }
    
    func fetchSpecificMessage(messageId: String) async throws -> Message {
        let message: Message = .init(messageId: messageId)
        let query = messageCollection.whereField("message_id", isEqualTo: messageId)
        
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents  {
                _ = try document.data(as: Message.self, decoder: decoder)
     
            }
        }
        return message
    }
    
    func deleteMessage(messageId: String) async throws {
        
        try await Firestore.firestore().collection("messages").document(messageId).delete()
        
    }
    
}

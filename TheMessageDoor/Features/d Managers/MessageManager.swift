//
//  MessageManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/9/25.
//

import FirebaseFirestore
import Foundation

final class MessageManager {
    
    static let shared = MessageManager()
    
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
    }
}

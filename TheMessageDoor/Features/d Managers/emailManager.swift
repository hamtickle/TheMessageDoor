//
//  emailManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/17/25.
//

import FirebaseFirestore
import Foundation

final class emailManager {
    
    static let instance = emailManager()
    private let emailCollection = Firestore.firestore().collection("mail")
    
    private init() {}
    
    private func emailDocument(email: Email) -> DocumentReference {
        return emailCollection.document(email.message.id)
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
    
    func sendEmail(email: Email) {
        
        print("Sending email to \(email.to)")
        
        do {
            try emailDocument(email: email).setData(
                from: email, merge: true, encoder: encoder)
            
//            try await emailCollection.document(email.id).setData(email)
            
        } catch {
            // Error updating order
            print("Error writing email \(email.to) \n \(error)")
        }
        
    }
    
}

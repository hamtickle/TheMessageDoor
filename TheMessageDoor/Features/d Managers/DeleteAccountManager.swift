//
//  DeleteAccountManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/12/25.
//

import FirebaseFirestore
import Foundation

final class DeleteAccount {

    static let shared = DeleteAccount()

    private init() {}

    private let messageCollection = Firestore.firestore().collection("messages")
    private let orderCollection = Firestore.firestore().collection("orders")
    private let userCollection = Firestore.firestore().collection("users")

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

    func deleteAccount(senderId: String) async throws {

        var querySnapshot = try await messageCollection.whereField(
            "sender_Id", isEqualTo: senderId
        ).getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }

         querySnapshot = try await orderCollection.whereField(
            "sender_Id", isEqualTo: senderId
        ).getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }

         querySnapshot = try await userCollection.whereField(
            "user_Id", isEqualTo: senderId
        ).getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }

}

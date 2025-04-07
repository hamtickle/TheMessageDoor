//
//  UserManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import FirebaseFirestore
import Foundation

final class UserManager {

    static let shared = UserManager()
    @Published var newUser: Bool = false
    private init() {}

    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
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

    func createNewUser(user: Profile) async throws {
        try userDocument(userId: user.userId).setData(
            from: user, merge: true, encoder: encoder)
    }

    func getUser(userId: String) async throws -> Profile {
//        do {
            try await userDocument(userId: userId).getDocument(
                as: Profile.self, decoder: decoder)
//        } catch {
//            print("user document doesn't exist")
//            newUser = true
//        }
//        return Profile(userId: userId)
    }

    func updateUser(user: Profile) async throws {
        try userDocument(userId: user.userId).setData(
            from: user, merge: true, encoder: encoder)
    }

}

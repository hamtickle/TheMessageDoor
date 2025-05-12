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
    @Published var currentReceiver: Profile?
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
        do {
            try userDocument(userId: user.userId).setData(
                from: user, merge: true, encoder: encoder)
        } catch {
            print("Error creating new user document: \(error)")
        }

    }

    func getUser(userId: String) async throws -> Profile {

        try await userDocument(userId: userId).getDocument(
            as: Profile.self, decoder: decoder)
    }

    func updateUser(user: Profile) async throws {
        do {
            try userDocument(userId: user.userId).setData(
                from: user, merge: true, encoder: encoder)
        } catch {
            print("Error updating user: \(error)")
        }
    }

    func getUserWithEmail(email: String) async throws -> Profile? {

        let query = userCollection.whereField("email", isEqualTo: email)

        do {
            let querySnapshot = try await query.getDocuments()

            for document in querySnapshot.documents {
                let _currentReceiver = try document.data(
                    as: Profile.self, decoder: decoder)
                currentReceiver = _currentReceiver
            }

            if currentReceiver == nil {
                newUser = true
                print("No user found.  New user \(email) created.")
            }
        } catch {
            // no User with that email exists
            print("No User with \(email) exists.")
            newUser = true
        }
        return currentReceiver
    }

}

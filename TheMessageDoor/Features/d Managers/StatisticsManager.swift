//
//  StatisticsManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/11/25.
//

import FirebaseFirestore
import Foundation

final class StatManager {

    static let instance = StatManager()
    private let statCollection = Firestore.firestore().collection("stats")
    var userStats: UserStats = UserStats(userId: "")

    private init() {}

    private func statDocument(userId: String) -> DocumentReference {
        return statCollection.document(userId)
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

    func updateStats(stats: UserStats) async throws {
        print("Updating User Stats for \(stats.userId) \n")
        do {
            try statDocument(userId: stats.userId).setData(
                from: stats, merge: true, encoder: encoder)
        } catch {
            // Error updating order
            print("Error updating order \(stats.userId) \n \(error)")
        }

    }

    func getUserStats(senderId: String) async throws -> UserStats {
        print("\n getting user Stats for \(senderId) \n")

        let query = statCollection.whereField("user_id", isEqualTo: senderId)

        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
    
                do {
                    var userStats = try document.data(
                        as: UserStats.self, decoder: decoder)
                    self.userStats = userStats
                } catch {
                    print("\n error on userStats decoding \(error)")
                }

            }
        } catch {
            print("\n Error getting documents: \(error) \n")
        }
        return userStats
    }

}

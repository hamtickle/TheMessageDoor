//
//  CheckUserWithEmail.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/22/25.
//

import Foundation

@MainActor
class CheckUserWithEmail: ObservableObject {
    
    var thisUser: Person = Person(userId: "")
        
    func fetchUserWithEmail(email: String) async throws -> Person {
        do {
            let result = try await UserManager.shared.getUserWithEmail(
                email: email)

            if let result {
                // unWrap the user that was found
                thisUser.userId = result.userId
                thisUser.email = result.email ?? ""
                thisUser.photoUrl = result.photoUrl ?? ""
                thisUser.dateCreated = result.dateCreated ?? Date()
                thisUser.firstName = result.firstName ?? ""
                thisUser.lastName = result.lastName ?? ""
                thisUser.myFont = result.myFont ?? ""
                thisUser.mySignature = result.mySignature ?? ""
                
                thisUser.totalMessagesSent = result.totalMessagesSent
                thisUser.totalMessagesCreated = result.totalMessagesCreated
                thisUser.totalMyFavorites = result.totalMyFavorites
                thisUser.totalReceiverFavorites = result.totalReceiverFavorites
                
            }
        } catch {
            print("no receiver with email: \(email) found")

        }
        return thisUser
    }
}

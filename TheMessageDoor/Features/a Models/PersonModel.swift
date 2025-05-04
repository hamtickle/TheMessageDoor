//
//  PersonModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/22/25.
//

import Foundation

struct Person: Identifiable, Codable {
    var userId : String
    var email : String
    var photoUrl : String
    var dateCreated : Date
    var firstName : String
    var lastName : String
    var myFont : String
    var mySignature : String
    var receiverKey : String
    
    var totalMessagesCreated : Int
    var totalMessagesSent : Int
    var totalMyFavorites: Int
    var totalReceiverFavorites: Int
    
    var id: String {userId}
    
    // initialize a Profile from individual values passed in
    init(
        userId: String,
        email: String = "",
        photoUrl: String = "",
        dateCreated: Date = Date(),
        firstName: String = "",
        lastName: String = "",
        myFont: String = "",
        mySignature: String = "",
        receiverKey: String = "",
        
        totalMessagesSent: Int = 0,
        totalMessagesCreated: Int = 0,
        totalMyFavorites: Int = 0,
        totalReceiverFavorites: Int = 0
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.firstName = firstName
        self.lastName = lastName
        self.myFont = myFont
        self.mySignature = mySignature
        self.receiverKey = receiverKey
        
        self.totalMessagesSent = totalMessagesSent
        self.totalMessagesCreated = totalMessagesCreated
        self.totalMyFavorites = totalMyFavorites
        self.totalReceiverFavorites = totalReceiverFavorites
    }
    
//    mutating func updateUserId(newUserId: String) {
//        userId = newUserId
//    }
    
    mutating func incrementTotalMessagesSent() {
        totalMessagesSent += 1
    }
    
    mutating func incrementTotalMessagesCreated() {
        self.totalMessagesCreated += 1
    }
    
    mutating func incrementTotalMyFavorites() {
        self.totalMyFavorites += 1
    }
    
    mutating func incrementTotalReceiverFavorites() {
        self.totalReceiverFavorites += 1
    }
    
    mutating func updateNames(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}

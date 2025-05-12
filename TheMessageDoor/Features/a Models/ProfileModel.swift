//
//  ProfileModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/6/25.
//

import Foundation
//import FirebaseFirestore

struct Profile: Codable {
    var userId : String
    var email : String?
    var photoUrl : String?
    var dateCreated : Date?
    var firstName : String?
    var lastName : String?
    var myFont : String?
    var mySignature : String?
    var receiverKey : String
    
    var totalMessagesCreated : Int
    var totalMessagesSent : Int
    var totalMyFavorites: Int
    var totalReceiverFavorites: Int
    
    var lastUpdated: Date
    
    
    // initialize a Profile from the Auth Model (of the current User)
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.firstName = nil
        self.lastName = nil
        self.myFont = nil
        self.mySignature = ""
        self.receiverKey = ""
        
        self.totalMessagesSent = 0
        self.totalMessagesCreated = 0
        self.totalMyFavorites = 0
        self.totalReceiverFavorites = 0
        
        self.lastUpdated = Date()
    }
    
    // initialize a Profile from individual values passed in
    init(
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        myFont: String? = nil,
        mySignature: String? = nil,
        receiverKey: String = "",
        
        totalMessagesSent: Int = 0,
        totalMessagesCreated: Int = 0,
        totalMyFavorites: Int = 0,
        totalReceiverFavorites: Int = 0,
        
        lastUpdated: Date = Date()
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
        
        self.lastUpdated = Date()
    }
    
    mutating func updateUserId (newUserId: String) {
        self.userId = newUserId
    }
    
    mutating func incrementTotalMessagesSent() {
        self.totalMessagesSent += 1
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
    
}

//
//  ProfileModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/6/25.
//

import Foundation
//import FirebaseFirestore

struct Profile: Codable {
    let userId : String
    let email : String?
    let photoUrl : String?
    let dateCreated : Date?
    let firstName : String?
    let lastName : String?
    let myFont : String?
    let mySignature : String?
    
    var totalMessagesCreated : Int
    var totalMessagesSent : Int
    var totalMyFavoriates: Int
    var totalReceiverFavorites: Int
    
    
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
        
        self.totalMessagesSent = 0
        self.totalMessagesCreated = 0
        self.totalMyFavoriates = 0
        self.totalReceiverFavorites = 0
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
        
        totalMessagesSent: Int = 0,
        totalMessagesCreated: Int = 0,
        totalMyFavoriates: Int = 0,
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
        
        self.totalMessagesSent = totalMessagesSent
        self.totalMessagesCreated = totalMessagesCreated
        self.totalMyFavoriates = totalMyFavoriates
        self.totalReceiverFavorites = totalReceiverFavorites
    }
    
    mutating func incrementTotalMessagesSent() {
        self.totalMessagesSent += 1
    }
    
    mutating func incrementTotalMessagesCreated() {
        self.totalMessagesCreated += 1
    }
    
    mutating func incrementTotalMyFavoriates() {
        self.totalMyFavoriates += 1
    }
    
    mutating func incrementTotalReceiverFavorites() {
        self.totalReceiverFavorites += 1
    }
    
}

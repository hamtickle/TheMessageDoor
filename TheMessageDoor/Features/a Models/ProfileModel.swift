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
    
    var newUser: Bool
    
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
     
        self.newUser = true
        
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
    
        newUser: Bool = false,
        
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

        self.newUser = newUser
        
        self.lastUpdated = Date()
    }
    
    mutating func updateUserId (newUserId: String) {
        self.userId = newUserId
    }
    
    mutating func updateNewUser (userId: String) {
        self.newUser = false
        self.lastUpdated = Date()
    }
    
    
}

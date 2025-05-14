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
    var newUser: Bool
 
    
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
        newUser: Bool = true
      
        
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

        
    }
    
    mutating func updateNames(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}

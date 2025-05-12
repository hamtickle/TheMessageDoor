//
//  StatModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/11/25.
//

import Foundation

struct UserStats: Codable {
    var userId : String
    
    var totalMessagesCreated : Int
    var totalMessagesSent : Int
    var totalMyFavorites: Int
    var totalReceiverFavorites: Int
    
    var lastUpdated: Date
    
    
    // initialize a Profile from the Auth Model (of the current User)
    init(userId: String) {
        self.userId = userId
        
        self.totalMessagesSent = 0
        self.totalMessagesCreated = 0
        self.totalMyFavorites = 0
        self.totalReceiverFavorites = 0
        
        self.lastUpdated = Date()
    }
    
    mutating func updateTotalMessagesSent() {
        self.totalMessagesSent += 1
        self.lastUpdated = Date()
    }
    
    mutating func updateTotalMessagesCreated() {
        self.totalMessagesCreated += 1
        self.lastUpdated = Date()
    }
    
    mutating func updateTotalMyFavorites() {
        self.totalMyFavorites += 1
        self.lastUpdated = Date()
    }
    
    mutating func updateTotalReceiverFavorites() {
        self.totalReceiverFavorites += 1
        self.lastUpdated = Date()
    }
}

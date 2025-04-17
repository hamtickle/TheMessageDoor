//
//  ProfileModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/6/25.
//

import Foundation
//import FirebaseFirestore

struct Order: Identifiable, Codable {
     
    let orderId : String
    let senderId : String?
    let senderFirstName : String?
    let senderLastName : String?
    
    let receiverId : String?
    let receiverFirstName : String?
    let receiverLastName : String?
    let receiverEmail: String?
    
    let orderType : String?
    let orderStatus : String?
    let orderDateCreated : Date?
    
    var id: String {orderId}
      
    // initialize a Profile from individual values passed in
    init(
        orderId: String,
        senderId: String? = nil,
        senderFirstName: String? = nil,
        senderLastName: String? = nil,
        
        receiverId: String? = nil,
        receiverFirstName: String? = nil,
        receiverLastName: String? = nil,
        receiverEmail: String? = nil,
        
        orderType: String? = nil,
        orderStatus: String? = nil,
        orderDateCreated: Date? = nil
    ) {
        self.orderId = UUID().uuidString
        self.senderId = senderId
        self.senderFirstName = senderFirstName
        self.senderLastName = senderLastName
        
        self.receiverId = receiverId
        self.receiverFirstName = receiverFirstName
        self.receiverLastName = receiverLastName
        self.receiverEmail = receiverEmail
        
        self.orderType = orderType
        self.orderStatus = orderStatus
        self.orderDateCreated = orderDateCreated
    }
    
}

struct ReceiverModel: Codable {
    
    let receiverId : String?
    let receiverFirstName : String?
    let receiverLastName : String?
    let receiverEmail: String?
    
    // initialize a Profile from individual values passed in
    init(
        
        receiverId: String? = nil,
        receiverFirstName: String? = nil,
        receiverLastName: String? = nil,
        receiverEmail: String? = nil
        
    ) {
        
        self.receiverId = receiverId
        self.receiverFirstName = receiverFirstName
        self.receiverLastName = receiverLastName
        self.receiverEmail = receiverEmail
        
    }
}

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
    
  
    let receiverFirstName : String?
    let receiverLastName : String?
    let receiverEmail: String
    
    let orderType : String?
    var orderStatus : String
    let orderDateCreated : Date
    let orderPrice : CGFloat?
    let orderExpirationDate : Date
    
    var id: String {orderId}
      
    // initialize a Profile from individual values passed in
    init(
        orderId: String,
        senderId: String? = nil,
        senderFirstName: String? = nil,
        senderLastName: String? = nil,
        
       
        receiverFirstName: String? = nil,
        receiverLastName: String? = nil,
        receiverEmail: String = "",
        
        orderType: String? = nil,
        orderStatus: String = "",
        orderDateCreated: Date = Date(),
        orderPrice: CGFloat? = nil,
        orderExpirationDate: Date = Date()
    ) {
        self.orderId = UUID().uuidString
        self.senderId = senderId
        self.senderFirstName = senderFirstName
        self.senderLastName = senderLastName
        
    
        self.receiverFirstName = receiverFirstName
        self.receiverLastName = receiverLastName
        self.receiverEmail = receiverEmail
        
        self.orderType = orderType
        self.orderStatus = orderStatus
        self.orderDateCreated = orderDateCreated
        self.orderPrice = orderPrice
        self.orderExpirationDate = orderExpirationDate
    }
    
}


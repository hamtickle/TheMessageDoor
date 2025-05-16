//
//  OrderTypeModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/14/25.
//

import Foundation
//import FirebaseFirestore

struct OrderType: Identifiable, Codable {
     
    let orderTypeId : String
    var type: String
    var price: CGFloat
    var description: String
    var minDuration: Int?
    
    var id: String {orderTypeId}
      
    // initialize a Profile from individual values passed in
    init(
        orderTypeId: String,
        type: String,
        price: CGFloat,
        description: String,
        minDuration: Int? = nil
        
    ) {
        self.orderTypeId = UUID().uuidString
        self.type = type
        self.price = price
        self.description = description
        self.minDuration = minDuration
    }
    
}

//
//  ReceiverManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class ReceiverManager: ObservableObject {
    
    @Published var receiverList: [String] = []
    @Published var receiverCount: Int = 0
    @Published var orderList: [Order] = []
    @Published var activeOrderCount: Int = 0
    @Published var activeOrders: [Order] = []
 
    func getReceivers(senderId: String) async throws -> [String] {
        let (result, orderList) = try await OrderManager.shared.getReceivers(senderId: senderId)
        
        // remove duplicates from receiverlist
        receiverList = result.unique()
        receiverCount = receiverList.count
        self.orderList = orderList
        sortReceivers()
        getActiveOrders()
        print (receiverList)
        return receiverList
    }
    
    func getActiveOrders() {
        activeOrders = orderList.filter { $0.orderStatus == "Active" }
        activeOrderCount = activeOrders.count
    }
    
    func sortReceivers() {
        receiverList.sort { (email1, email2) -> Bool in
            return email1 < email2
        }
    }
    
    func getReceiverInfo(email: String) -> (String, String, String) {
        let order : Order = orderList.filter {
            order in
            if order.receiverEmail == email {
                return true
            }
            return false
        }.first!
        
        return (order.receiverFirstName ?? "", order.receiverLastName ?? "", order.receiverId ?? "")
    }
    
}

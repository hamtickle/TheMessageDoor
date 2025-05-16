//
//  OrderListVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation
//
//  OrderViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import Foundation

@MainActor
class OrderListVM: ObservableObject {
    

    private var k: Constants = Constants()
    @Published var noOrders: Bool = false
    
    @Published private(set) var order: Order? = nil
    
    @Published var orderList: [Order] = []
    @Published var activeOrders: [Order] = []
  
    @Published var updateOrderSuccessful: Bool = false
    
    init () {}
    
    func fetchSenderOrders(senderId: String) async throws {
        print("\n fetchSenderOrders")
        
        do {
            let result = try await OrderManager.shared.getOrders(senderId: senderId)
            self.orderList = result.map(\.self)
            sortOrdersByRecipient()
            
        } catch {
            print("issue with retrieving orders for \(senderId): \(error)")
        }
        
        let activeOrders = orderList.filter({ $0.orderStatus == k.statusActive }).count
        if activeOrders == 0 {
            noOrders = true
        } else {
            noOrders = false
        }
    }
    
    // Sort Orders
    func sortOrdersByRecipient() {
        orderList.sort { (lhs: Order, rhs: Order) -> Bool in
            return lhs.receiverEmail! < rhs.receiverEmail!
        }
    }
    
}



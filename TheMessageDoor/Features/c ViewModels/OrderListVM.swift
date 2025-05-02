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
    
    var pVM = ProfileViewModel()
    private var k: Constants = Constants()
    @Published var noOrders: Bool = false
    
    @Published var selectedReceiverEmail: String = ""
    
    @Published var receiverList: [String] = []
    
    @Published var thisReceiverId: String = ""
    @Published var thisReceiverFirst: String = ""
    @Published var thisReceiverLast: String = ""
    
    @Published private(set) var order: Order? = nil
    
    @Published var currentReceiverId: String = ""
    @Published var currentReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""

    @Published var currentOrderDateCreated: Date = Date()
    @Published var currentOrderStatus: String = ""
    @Published var currentOrderType: String = ""
    
    @Published var orderList: [Order] = []
    @Published var activeOrders: [Order] = []
  
    @Published var updateOrderSuccessful: Bool = false
    
    init () {}
    
    func fetchSenderOrders(senderId: String) async throws {
        let result = try await OrderManager.shared.getOrders(senderId: senderId)
        self.orderList = result.map(\.self)
        sortOrdersByRecipient()
        
        var activeOrders = orderList.filter({ $0.orderStatus == k.statusActive }).count
        if activeOrders == 0 {
            noOrders = true
        }
    }
    
    // Sort Orders
    func sortOrdersByRecipient() {
        orderList.sort { (lhs: Order, rhs: Order) -> Bool in
            return lhs.receiverEmail! < rhs.receiverEmail!
        }
    }
    
}



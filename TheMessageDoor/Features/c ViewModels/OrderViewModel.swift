//
//  OrderViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
    
    var pVM = ProfileViewModel()
    
    @Published var selectedReceiverEmail: String = ""
    
    @Published var receiverList: [String] = []
    @Published var receiverData: [ReceiverModel] = []
    
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
  
    
    @Published var updateOrderSuccessful: Bool = false
    
//    func getSenderOrders(userId: String) async throws -> [Order] {
//        return try await OrderManager.shared.getSenderOrders(userId: userId)
//    }
    
    
    func loadCurrentOrder(orderId: String) async throws {
        self.order = try await OrderManager.shared.getOrder(orderId: orderId)
        unwrapOrder()
    }
    
    func unwrapOrder() {
        currentReceiverId = self.order?.receiverId ?? ""
        currentReceiverEmail = self.order?.receiverEmail ?? ""
        currentReceiverFirstName = self.order?.receiverFirstName ?? ""
        currentReceiverLastName = self.order?.receiverLastName ?? ""

        currentOrderDateCreated = self.order?.orderDateCreated ?? Date()
        currentOrderType = self.order?.orderType ?? ""
        currentOrderStatus = self.order?.orderStatus ?? ""
    }
    
    func createOrder(senderId: String, senderFirstName: String, senderLastName: String, receiverId: String, receiverEmail: String, receiverFirstName: String, receiverLastName: String) {
        
        let updatedOrder = Order(orderId: "",
                                 senderId: senderId,
                                 senderFirstName:senderFirstName ,
                                 senderLastName: senderLastName,
                                 receiverId: receiverId,
                                 receiverFirstName: receiverFirstName,
                                 receiverLastName: receiverLastName,
                                 receiverEmail: receiverEmail,
                                 orderType: "monthly",
                                 orderStatus: "Active",
                                 orderDateCreated: Date())
        Task {
            try await OrderManager.shared.createNewOrder(order: updatedOrder)
            updateOrderSuccessful.toggle()
        }
 
    }
    
    func getReceivers(senderId: String) async throws{
        var (result, receiverData) = try await OrderManager.shared.getReceivers(senderId: senderId)
        // remove duplicates from receiverlist
        receiverList = result.unique()
        self.receiverData = receiverData
    }
    
    func getReceiverProperties(receiverEmail: String) {
        if let offset = receiverData.firstIndex(where: {$0.receiverEmail == receiverEmail})
        {
            let currentReceiverId = receiverData[offset].receiverId ?? ""
            let currentReceiverFirstName = receiverData[offset].receiverFirstName ?? ""
            let currentReceiverLastName = receiverData[offset].receiverLastName ?? ""
        }
        
    }
  
    
    
    
//    func updateUser(email: String, firstName: String, lastName: String, myFont: String, mySignature: String) {
//        guard let order else { return }
//        
//        let updatedUser = Profile(userId: user.userId, email: email, photoUrl: user.photoUrl, firstName: firstName, lastName: lastName, myFont: myFont, mySignature: ""  )
//        Task {
//            try await UserManager.shared.updateUser(user: updatedUser)
//            self.user = try await UserManager.shared.getUser(userId: user.userId)
//            updateSuccessful.toggle()
//        }
//    }
}

extension Array where Element: Equatable {
    func unique() -> [Element] {
        self.reduce([]) {result, element in
            result.contains(element) ? result : result + [element]
        }
    }
}



//
//  OrderCreateVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class OrderCreateVM: ObservableObject {
    
    private var rm: ReceiverManager = ReceiverManager()
  
    @Published var selectedReceiverEmail: String = ""
    
    @Published var receiverList: [String] = []
    
    @Published private(set) var order: Order? = nil
    
    @Published var currentReceiver: Profile? = nil
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
    @Published var duplicateOrders: Bool = false
    
    init () { }
    
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
    
    func createOrder(senderId: String, senderFirstName: String, senderLastName: String, receiverId: String, receiverEmail: String, receiverFirstName: String, receiverLastName: String)
    
    {
        let updatedOrder = Order(orderId: "", senderId: senderId,senderFirstName:senderFirstName ,senderLastName: senderLastName,receiverId: receiverId,receiverFirstName: receiverFirstName,receiverLastName: receiverLastName,receiverEmail: receiverEmail,orderType: "monthly",orderStatus: "Active",orderDateCreated: Date())
        Task {
            try await OrderManager.shared.createNewOrder(order: updatedOrder)
            updateOrderSuccessful.toggle()
        }
        
    }
    
    func getReceivers(senderId: String) async throws {
        receiverList = try await rm.getReceivers(senderId: senderId)
    }
    
    func fetchSenderOrders(senderId: String) async throws {
        let result = try await OrderManager.shared.getOrders(senderId: senderId)
        self.orderList = result.map(\.self)
        sortOrdersByRecipient()
    }
    
    // Sort Orders
    func sortOrdersByRecipient() {
        orderList.sort { (lhs: Order, rhs: Order) -> Bool in
            return lhs.receiverEmail! < rhs.receiverEmail!
        }
    }
    
    func getReceiver(email: String) async throws {
        do {
            currentReceiver = try await UserManager.shared.getUserWithEmail(
                email: email)
            
            currentReceiverId = self.currentReceiver?.userId ?? ""
            currentReceiverFirstName = self.currentReceiver?.firstName ?? ""
            currentReceiverLastName = self.currentReceiver?.lastName ?? ""
            currentReceiverEmail = self.currentReceiver?.email ?? ""
        } catch {
            print("no receiver with email: \(email) found")
            
        }
    }
    
    func createReceiver(
        userId: String, email: String, firstName: String, lastName: String,
        myFont: String, mySignature: String
    ) async throws {

        // check receiver is not already registered
        do {
            try await getReceiver(email: email)
        } catch  {
            print("creating new receiver: \(email)")
        }
       

        if UserManager.shared.newUser {
            let receiverUser = Profile(
                userId: userId, email: email, photoUrl: "no photo on file",
                dateCreated: Date(), firstName: firstName, lastName: lastName,
                myFont: myFont, mySignature: mySignature)

            Task {
                do {
                    try await UserManager.shared.updateUser(user: receiverUser)
    //                updateSuccessful.toggle()
                } catch {
                    print("error creating receiver: \(error)")
                    throw error
                }

            }
        }

    }
    
    func getReceiverInfo(email: String) {
        var First: String = ""
        var Last: String = ""
        var Id: String = ""
        (First, Last, Id) = rm.getReceiverInfo(email: email)
        
        currentReceiverId = Id
        currentReceiverFirstName = First
        currentReceiverLastName = Last
        currentReceiverEmail = email
    }
    
    func checkIfActiveOrderExists(email: String) {
        duplicateOrders = false
        duplicateOrders = rm.activeOrders.contains(where: { $0.receiverEmail == email })
   
    }
}



extension Array where Element: Equatable {
    func unique() -> [Element] {
        self.reduce([]) {result, element in
            result.contains(element) ? result : result + [element]
        }
    }
}


//
//  OrderCreateVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class OrderCreateVM: ObservableObject {
    
    private var k: Constants = Constants()
    private var rm: ReceiverManager = ReceiverManager()
    private var checkEmail: CheckUserWithEmail = CheckUserWithEmail()
 
  
    @Published var receiverList: [String] = []
    @Published var selectedReceiverEmail: String = ""
    @Published var currentReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""

    @Published var orderList: [Order] = []
    @Published var activeOrders: [Order] = []
    @Published var orderTypes: [OrderType] = []
    @Published var orderTypeList: [String] = []
    
    @Published var updateOrderSuccessful: Bool = false
    @Published var duplicateOrders: Bool = false
    @Published var initializeOVM: Bool = true
    
    
    init () {
            print("\n init of OrderCreateVM")
            
            let blankOrderType = OrderType(orderTypeId: "", type: "Select Order Type", price: 0.0, description: "Please select an order type from the options available.", minDuration: 0)
            orderTypes.append(blankOrderType)
        
    //        print("\n seeding of orderTypes array: \(orderTypes)")
//            Task {
//                try await getOrderTypes()
//            }
        
    }
    
    func createOrderButtonTapped(user: Person, first: String, last: String, email: String) {
 
        //check for duplicate orders
        checkIfActiveOrderExists(email: email)
        
        if duplicateOrders
            {
            print("order already exists")
        } else {
            createOrder(
                senderId: user.userId,
                senderFirstName: user.firstName,
                senderLastName: user.lastName,

//                receiverId: currentReceiverId,
                receiverEmail: email,
                receiverFirstName: first,
                receiverLastName: last
                
            )
            
            selectedReceiverEmail = "New Recipient"
            }
        }
    
    
    
    func createOrder(senderId: String, senderFirstName: String, senderLastName: String,  receiverEmail: String, receiverFirstName: String, receiverLastName: String)
    
    {
        let updatedOrder = Order(orderId: "", senderId: senderId,senderFirstName:senderFirstName ,senderLastName: senderLastName,receiverFirstName: receiverFirstName,receiverLastName: receiverLastName,receiverEmail: receiverEmail,orderType: "monthly",orderStatus: "Active",orderDateCreated: Date())
        Task {
            try await OrderManager.shared.createNewOrder(order: updatedOrder)
            updateOrderSuccessful.toggle()
        }
        
    }
    
    func getReceivers(senderId: String) async throws {
        print("\n oVM: getReceivers")
        receiverList = try await rm.getReceivers(senderId: senderId)
    }
    
    func fetchSenderOrders(senderId: String) async throws {
        print("\n oVM: fetchSenderOrders")
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
        print("\n oVM: getReceiver")
        _ = try await checkEmail.fetchUserWithEmail(email: email)
    }
    
    
    func getReceiverInfo(email: String) {
        print("\n oVM: getReceiverInfo")
        var First: String = ""
        var Last: String = ""
     
        (First, Last) = rm.getReceiverInfo(email: email)
        
        currentReceiverFirstName = First
        currentReceiverLastName = Last
        currentReceiverEmail = email
    }
    
    func checkIfActiveOrderExists(email: String) {
        duplicateOrders = false
        duplicateOrders = rm.activeOrders.contains(where: { $0.receiverEmail == email })
   
    }
    
    func getOrderTypes() async throws{
        print("\n oVM: getOrderTypes")
        
        orderTypes = try await OrderManager.shared.getOrderTypes()
        self.orderTypes = orderTypes
 
        
        // select out the order types into an array
        for each in orderTypes {
            orderTypeList.append(each.type)
        }
 
    }
}



extension Array where Element: Equatable {
    func unique() -> [Element] {
        self.reduce([]) {result, element in
            result.contains(element) ? result : result + [element]
        }
    }
}


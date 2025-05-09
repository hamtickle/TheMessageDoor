////
////  TabBarVM.swift
////  TheMessageDoor
////
////  Created by Graham Tickell on 5/4/25.
////
//
//import Foundation
//
//@MainActor
//class AppVM: ObservableObject {
//
//    private var k: Constants = Constants()
//    @Published var currentUser: Person
//    @Published var orderList: [Order?] = []
//    @Published var receiverList: [String] = []
//    @Published var senderMessages: [Message?] = []
//    @Published var receiverMessages: [Message?] = []
//
//    @Published var selectedTab: Int = 0
//    @Published var showLoadingScreen: Bool = true
//    @Published var incompleteProfile: Bool = false
//
//    
//    init() {
//        //  get User Profile data  (returns Person)
////        currentUser = GetCurrentUser.fetchUserDefaults()
////        print("\n appvm init: currentUser: \(currentUser)")
//
//        // check if Profile is complete
//        if currentUser.firstName == "" {
//            incompleteProfile = true
//        }
//
//        // set Loading screen
//        showLoadingScreen = true
//        //  get User data
////        try? getUserData()
////        print("\n appVM init \n orderList: \(orderList) \n receiverList: \(receiverList) \n senderMessages: \(senderMessages) \n receiverMessages: \(receiverMessages)")
//
//        // release loading screen
//        showLoadingScreen = false
//    }
//
//    func getUserData() throws {
//        
//        Task {
//            do {
//                //  get orders  (returns [orderList])
//                try await orderList = OrderManager.shared.getOrders(
//                    senderId: currentUser.userId)
//            } catch {
//                print("error getting orders: \(error)")
//            }
//            print("\n Completed appVM get OrderList")
//        }
//
//        Task {
//            do {
//                //  get orders  (returns [orderList])
////                async let getOrders = OrderManager.shared.getOrders(
////                    senderId: currentUser.userId)
//                //  get receivers (returns [receivers])
//                async let getReceivers = OrderManager.shared.getReceivers(
//                    senderId: currentUser.userId)
//                //  get sender messages (returns [senderMessages])
//                async let getSenderMessages = MessageManager.shared.getMessages(
//                    senderId: currentUser.userId)
//                //  get receiver messages (returns [receiverMessages]
//                async let getReceiverMessages = MessageManager.shared
//                    .getReceiverMessages(receiverId: currentUser.userId)
//
//                let (
//                    (receiverList, _), senderMessages, receiverMessages
//                ) =
//                    await (
//                        try getReceivers,
//                        try getSenderMessages, try getReceiverMessages
//                    )
//                print("\n TASK: \n orderList \(orderList) \n receiverList: \(receiverList) \n senderMessages: \(senderMessages) \n receiverMessages: \(receiverMessages)")
//
//            }
//        }
//
//    }
//
//}

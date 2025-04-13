//
//  OrderModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import FirebaseFirestore
import Foundation

final class OrderManager {

  
    static let shared = OrderManager()
    @Published var newUser: Bool = false
    private init() {}
    private var receiverList: [String] = []

    private let orderCollection = Firestore.firestore().collection("orders")
    private func orderDocument(orderId: String) -> DocumentReference {
        return orderCollection.document(orderId)
    }

    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func createNewOrder(order: Order) async throws {
        try orderCollection.document(order.orderId).setData(
            from: order, merge: true, encoder: encoder)
    }

    func getOrder(orderId: String) async throws -> Order {
        try await orderDocument(orderId: orderId).getDocument(
            as: Order.self, decoder: decoder)
    }

    func updateOrder(order: Order) async throws {
        try orderDocument(orderId: order.orderId).setData(
            from: order, merge: true, encoder: encoder)
    }

    // find all the people Sender has already sent messages to from the orders.
    func getReceivers(senderId: String) async throws -> ([String], [ReceiverModel]) {
        var receiverOrders: [Order] = []
        var receiverData: [ReceiverModel] = []
        var thisReceiver: ReceiverModel
        let query = orderCollection.whereField("sender_id", isEqualTo: senderId)
  
        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents  {
                let order = try document.data(as: Order.self, decoder: decoder)
                receiverOrders.append(order)
            }
            
            // create an array of recipient emails and an array of recipient details
            
                receiverList.removeAll()
                for order in receiverOrders {
                    receiverList.append(order.receiverEmail ?? "")
                    
                    // unpack optionals
                    var thisReceiverId = order.receiverId ?? ""
                    var thisReceiverFirstName = order.receiverFirstName ?? ""
                    var thisReceiverLastName = order.receiverLastName ?? ""
                    var thisReceiverEmail = order.receiverEmail ?? ""
                    
                    var thisReceiver = ReceiverModel(receiverId: thisReceiverId, receiverFirstName: thisReceiverFirstName, receiverLastName: thisReceiverLastName, receiverEmail: thisReceiverEmail)
                    receiverData.append(thisReceiver)
                }
            
        }
        return (receiverList, receiverData)
    }
    
    func deleteSenderOrder(orderId: String) async throws {
        
        let querySnapshot = try await orderCollection.whereField("order_Id", isEqualTo: orderId).getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }

}

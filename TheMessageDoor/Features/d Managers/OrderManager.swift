//
//  OrderModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import FirebaseFirestore
import Foundation

@MainActor
final class OrderManager {

    static let shared = OrderManager()
    @Published var newUser: Bool = false
    @Published var order: Order? = nil
  
    private init() {}
    private var receiverList: [String] = []

    private let orderCollection = Firestore.firestore().collection("orders")

    private func orderDocument(orderId: String) -> DocumentReference {
        return orderCollection.document(orderId)
    }

    private let orderTypeCollection = Firestore.firestore().collection(
        "order_type")

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
        do {
            try orderCollection.document(order.orderId).setData(
                from: order, merge: true, encoder: encoder)
        } catch {
            // Error creating or updating an order
            print("Error creating or updating an order: \(error)")
        }

    }

    func updateOrder(order: Order) async throws {
        do {
            try orderDocument(orderId: order.orderId).setData(
                from: order, merge: true, encoder: encoder)
        } catch {
            // Error updating order
            print("Error updating order \(order.orderId) \n \(error)")
        }

    }

    // find all the people Sender has already sent messages to from the orders.
    func getReceivers(senderId: String) async throws -> ([String], [Order]) {
        print("\n getReceivers")
        var receiverOrders: [Order] = []

        let query = orderCollection.whereField("sender_id", isEqualTo: senderId)

        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
                //                print (document)
                do {
                    let order = try document.data(
                        as: Order.self, decoder: decoder)
                    receiverOrders.append(order)
                } catch {
                    print("Error decoding order \n \(error)")
                }

            }
            // create an array of recipient emails and an array of recipient details

            receiverList.removeAll()
            for order in receiverOrders {
                receiverList.append(order.receiverEmail ?? "")
            }

        } catch {
            // Error retrieving orders for receivers
            print("Error retrieving orders for receivers \n \(error)")
        }
        return (receiverList, receiverOrders)
    }

    func deleteSenderOrder(orderId: String) async throws {

        let querySnapshot = try await orderCollection.whereField(
            "order_Id", isEqualTo: orderId
        ).getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }

    func getOrders(senderId: String) async throws -> [Order] {
        print("\n getting order list for \(senderId) \n")
        var orderList: [Order] = []
        let query = orderCollection.whereField("sender_id", isEqualTo: senderId)

        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {
 
                do {
                    let order = try document.data(
                        as: Order.self, decoder: decoder)
                    orderList.append(order)
                } catch {
                    print("\n error on order decoding \(error)")
                }

            }
        } catch {
            print("\n Error getting documents: \(error) \n")
        }
        return orderList
    }

    func getOrderTypes() async throws -> [OrderType] {
        print("\n OrderManager getting ordertypes list \n")

        var orderTypeList: [OrderType] = []
        let query = orderTypeCollection

        do {
            let querySnapshot = try await query.getDocuments()
            for document in querySnapshot.documents {

                do {
                    let result = try document.data(
                        as: OrderType.self, decoder: decoder)

                    orderTypeList.append(result)
//                    print("\n \(orderTypeList)")

                } catch {
                    print("\n error on order type decoding \(error)")
                }

            }
        } catch {
            print("\n Error getting documents: \(error) \n")
        }

        return orderTypeList
    }

}

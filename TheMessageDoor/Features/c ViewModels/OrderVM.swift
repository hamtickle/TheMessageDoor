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

@MainActor
class OrderVM: ObservableObject {

    private var k: Constants = Constants()
    private var rm: ReceiverManager = ReceiverManager()
    private var checkEmail: CheckUserWithEmail = CheckUserWithEmail()

    @Published private(set) var order: Order? = nil

    @Published var orderList: [Order] = []
    @Published var allOrders: [Order] = []
    @Published var activeOrders: [Order] = []

    //    Order Create variables
    @Published var receiverList: [String] = []
    @Published var selectedReceiverEmail: String = ""
    @Published var currentReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""

    @Published var orderTypes: [OrderType] = []
    @Published var orderTypeList: [String] = []

    @Published var duplicateOrders: Bool = false
    @Published var initializeOVM: Bool = true
    @Published var updateOrderSuccessful: Bool = false
    @Published var noOrders: Bool = false

    @Published var orderExpDate: Date = Date()
    @Published var orderExpired: Bool = false

    init() {
        orderTypes.append(
            OrderType(
                orderTypeId: "1", type: "", price: 0.0, description: "",
                minDuration: 0))

        let user = GetCurrentUser.shared.fetchUserDefaults()
        print("ovm init - \(user)")

        Task {
            try await fetchSenderOrders(
                senderId: user.userId)
        }

        Task {
            print("get Receivers for \(user.userId)")
            try? await getReceivers(
                senderId: user.userId)
        }

        Task {
            try await getOrderTypes()
        }

    }

    //    MARK: Order List Functions

    func fetchSenderOrders(senderId: String) async throws {
        print("\n fetchSenderOrders")

        do {
            let result = try await OrderManager.shared.getOrders(
                senderId: senderId)
            self.allOrders = sortOrders(orders: result).map(\.self)

        } catch {
            print("issue with retrieving orders for \(senderId): \(error)")
        }

        let result = allOrders.filter({ $0.orderStatus == k.statusActive })

        self.activeOrders = sortOrders(orders: result)

        self.orderList = activeOrders

        let activeOrders = activeOrders.count

        if activeOrders == 0 {
            noOrders = true
        } else {
            noOrders = false
        }
    }

    // Sort Orders
    func sortOrders(orders: [Order]) -> [Order] {

        let result = orders.sorted { (lhs: Order, rhs: Order) in
            if lhs.orderStatus != rhs.orderStatus {
                return lhs.orderStatus < rhs.orderStatus
            } else {
                return lhs.receiverEmail < rhs.receiverEmail
            }
        }
        return result

    }

    //    MARK: Order Create Functions

    func createOrderButtonTapped(
        user: Person, first: String, last: String, email: String,
        orderType: String
    ) {

        //check for duplicate orders
        checkIfActiveOrderExists(email: email)

        var orderExpirationDate = calculateExpirationDate(
            orderType: orderType, orderDateCreated: Date())

        if duplicateOrders {
            print("order already exists")
        } else {
            createOrder(
                senderId: user.userId,
                senderFirstName: user.firstName,
                senderLastName: user.lastName,

                receiverEmail: email,
                receiverFirstName: first,
                receiverLastName: last,

                orderType: orderType,
                orderExpirationDate: orderExpirationDate
            )

            selectedReceiverEmail = "New Recipient"
            Task {
                try await fetchSenderOrders(senderId: user.userId)
            }
            Task {
                try await getReceivers(senderId: user.userId)
            }

        }
    }

    func createOrder(
        senderId: String, senderFirstName: String, senderLastName: String,
        receiverEmail: String, receiverFirstName: String,
        receiverLastName: String, orderType: String, orderExpirationDate: Date
    ) {
        let updatedOrder = Order(
            orderId: "", senderId: senderId, senderFirstName: senderFirstName,
            senderLastName: senderLastName,
            receiverFirstName: receiverFirstName,
            receiverLastName: receiverLastName, receiverEmail: receiverEmail,
            orderType: orderType, orderStatus: "Active",
            orderDateCreated: Date(), orderExpirationDate: orderExpirationDate)
        Task {
            try await OrderManager.shared.createNewOrder(order: updatedOrder)
            updateOrderSuccessful.toggle()
        }

    }

    func getReceivers(senderId: String) async throws {
        print("\n oVM: getReceivers")
        receiverList = try await rm.getReceivers(senderId: senderId)
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
        duplicateOrders = rm.activeOrders.contains(where: {
            $0.receiverEmail == email
        })

    }

    func getOrderTypes() async throws {
        print("\n oVM: getOrderTypes")

        orderTypes = try await OrderManager.shared.getOrderTypes()
        self.orderTypes = orderTypes

        // select out the order types into an array
        for each in orderTypes {
            orderTypeList.append(each.type)
        }

    }

    func calculateExpirationDate(orderType: String, orderDateCreated: Date)
        -> Date
    {

        if orderType == k.type30Day {
            orderExpDate = orderDateCreated.addingTimeInterval(
                60 * 60 * 24 * 30)
        } else if orderType == k.typeMonthly {
            orderExpDate = orderDateCreated.addingTimeInterval(
                60 * 60 * 24 * 30)
        } else if orderType == k.typeAnnual {
            orderExpDate = orderDateCreated.addingTimeInterval(
                60 * 60 * 24 * 365)
        }

        return orderExpDate

    }

}

extension Array where Element: Equatable {
    func unique() -> [Element] {
        self.reduce([]) { result, element in
            result.contains(element) ? result : result + [element]
        }
    }
}

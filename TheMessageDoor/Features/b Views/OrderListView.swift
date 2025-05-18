//
//  OrderListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderListView: View {

    var k: Constants = Constants()
    @StateObject var user: GetCurrentUser
    @StateObject var vm: OrderListVM

    @Environment(\.colorScheme) var colorScheme
    @State private var loading: Bool = false

    init() {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: OrderListVM())
//    _ovm = StateObject(wrappedValue: OrderCreateVM())
    }

    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                Text("\(user.currentUser.firstName)'s Orders")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                NavigationLink {
                    OrderCreate(currentUser: user.currentUser, noOrders: $vm.noOrders)
                } label: {
                    Image(systemName: "cart")
                        .font(.system(size: 20))
                        .foregroundColor(
                            colorScheme == .dark ? Color.blue : Color.blue
                        )
                        .padding(.trailing, 10)
                }

            }
            .padding(.top, 30)

            List(vm.orderList, id: \.orderId) { order in
                NavigationLink(
                    destination: OrderView(user: user.currentUser, order: order)
                ) {

                    HStack(alignment: .top) {
                        OrderCell(order: order)
                            .frame(width: 300)
                        //                            .padding(.vertical, 0)
                        //                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Your Orders"))
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .task {
            loading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                let appUser = user.currentUser
                print("appUser: \(appUser)")
                do {
                    Task {
                        try await vm.fetchSenderOrders(
                            senderId: appUser.userId)
                    }
                }
                loading = false
            }
        }
//        .alert(
//            isPresented: $vm.noOrders,
//            content: {
//                Alert(
//                    title: Text("No Active Orders"),
//                    message: Text(
//                        "You do not have any ACTIVE orders.  \n Please create an order so you can send messages."
//                    ),
//                    dismissButton: .cancel(Text("OK"))
//                )
//            })
        .fullScreenCover(isPresented: $vm.noOrders) {
            NavigationStack {
                OrderCreate(currentUser: user.currentUser, noOrders: $vm.noOrders)
            }
        }
//        .environmentObject(ovm)
    }
      
}

#Preview {
    NavigationStack {
        OrderListView()
    }

}

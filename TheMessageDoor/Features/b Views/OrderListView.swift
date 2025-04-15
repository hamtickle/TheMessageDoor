//
//  OrderListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderListView: View {

    @StateObject private var oVM = OrderViewModel()
    @StateObject private var pVM = ProfileViewModel()
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        VStack(alignment: .center) {
            HStack {
                Text("\(pVM.currentUserFirstName)'s Orders")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                NavigationLink{
                    OrderCreate()
                } label: {
                    Image(systemName: "cart")
                        .font(.system(size: 34))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.trailing, 10)
                }
                
                
            }
            .padding(.top, 30)
            
            
            List(oVM.orderList, id: \.orderId) { order in
                NavigationLink(destination: OrderView(order: order)) {

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
        .onAppear {

            do {
                Task {
                    try? await pVM.loadCurrentUser()
                    try await oVM.fetchSenderOrders(
                        senderId: pVM.currentUserId)
                }
            }

        }
    }
}

#Preview {
    NavigationStack {
        OrderListView()
    }
}

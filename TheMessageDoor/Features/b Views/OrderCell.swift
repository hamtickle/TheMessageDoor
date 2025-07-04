//
//  OrderCellView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderCell: View {

    var k: Constants = Constants()
    @State var order: Order
    @ObservedObject var vm: OrderVM
    @Environment(\.colorScheme) var colorScheme
    @State var orderExpired: Bool = false

    var body: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .top) {
                Text(order.receiverFirstName ?? "")
                    .foregroundColor(
                        orderExpired
                            ? Color.gray : Color.blue
                    )
                    .font(.body)
                    .fontWeight(.bold)

                Text(order.receiverLastName ?? "")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(
                      orderExpired
                            ? Color.gray : Color.blue
                    )
            }

            HStack(alignment: .top) {
                Text(order.receiverEmail ?? "")
                    .foregroundColor(
                        orderExpired
                            ? Color.gray : Color.blue
                    )
                    .font(.body)

                Spacer()

                
                Text(orderExpired ? k.statusExpired : k.statusActive)
                    .font(.body)
                    .foregroundColor(
                        orderExpired
                            ? Color.gray : Color.green
                    )
            }
            .padding(.horizontal, 10)

            HStack(alignment: .top) {
                Text("Expiration Date: ")
                    .font(.caption)
                    .foregroundColor(Color.gray)

                Text(
                    order.orderExpirationDate,
                    format: Date.FormatStyle(date: .numeric)
                )
                .font(.caption)
                .foregroundColor(Color.gray)
            }
            .padding(.horizontal, 10)

            HStack(alignment: .top) {
                Text("Order Type: ")
                    .font(.caption)
                    .foregroundColor(Color.gray)

                Text(
                    order.orderType ?? ""
                )
                .font(.caption)
                .foregroundColor(Color.gray)
            }
            .padding(.horizontal, 10)

        }

        .padding(.vertical, 10)
        .frame(width: 300, height: 70, alignment: .leading)

        .task {
            if order.orderExpirationDate < Date() {
                orderExpired = true
            } else {
                orderExpired = false
            }
        }

    }
}

#Preview {
    
    NavigationStack    {

        OrderCell(order: Order(orderId: "123"), vm: OrderVM())
    }

}

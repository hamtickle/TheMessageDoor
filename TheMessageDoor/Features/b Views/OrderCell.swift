//
//  OrderCellView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderCell: View {

    @StateObject var oVM = OrderViewModel()

    @State var order: Order
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        ZStack {
//            Rectangle()
//                .fill(
//                    order.orderStatus!.contains("Active")
//                        ? Color(
//                            #colorLiteral(
//                                red: 0.1764705926, green: 0.4980392158,
//                                blue: 0.7568627596, alpha: 1)) : Color.black
//                )
//                .frame(width: 350, height: 50)
//                .cornerRadius(10)
            HStack {

                VStack(alignment: .leading) {

                    HStack(alignment: .top) {
                        Text(order.receiverEmail ?? "")
                            .foregroundColor(order.orderStatus!.contains("Active") ?
                                Color.blue : Color.gray
                            )
                            .font(.body)
                            .lineLimit(1)
                            .bold()
                            .padding(.trailing, 20)

                        Text(order.orderStatus ?? "")
                            .font(.body)
                            .foregroundColor(order.orderStatus!.contains("Active") ?
                                Color.blue : Color.gray
                            )
                    }

                    Text(order.orderId)
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }

                .padding(.horizontal, -10)
                .padding(.vertical, 0)
                .frame(width: 400, height: 50)

            }
            .padding(.horizontal, 30)
        }

    }
}

#Preview {
    var order: Order!

    OrderCell(order: order)
}

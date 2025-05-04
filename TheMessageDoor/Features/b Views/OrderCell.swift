//
//  OrderCellView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderCell: View {

    @State var order: Order
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        VStack(alignment: .leading) {

            HStack(alignment: .top) {
                Text(order.receiverFirstName ?? "")
                    .foregroundColor(
                        order.orderStatus!.contains("Active")
                            ? Color.blue : Color.gray
                    )
                    .font(.body)
                    .fontWeight(.bold)


                Text(order.receiverLastName ?? "")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(
                        order.orderStatus!.contains("Active")
                            ? Color.blue : Color.gray
                    )
            }
        

            HStack(alignment: .top) {
                Text(order.receiverEmail ?? "")
                    .foregroundColor(
                        order.orderStatus!.contains("Active")
                            ? Color.gray : Color.gray
                    )
                    .font(.body)

Spacer()

                Text(order.orderStatus ?? "")
                    .font(.body)
                    .foregroundColor(
                        order.orderStatus!.contains("Active")
                            ? Color.green : Color.gray
                    )
            }
            .padding(.horizontal, 10)
         

            HStack(alignment: .top) {
                Text("Date Created: ")
                    .font(.caption)
                    .foregroundColor(Color.gray)

                Text(
                    order.orderDateCreated ?? Date(),
                    format: Date.FormatStyle(date: .numeric)
                )
                .font(.caption)
                .foregroundColor(Color.gray)
            }
            .padding(.horizontal, 10)
     

        }

  
        .padding(.vertical, 0)
        .frame(width: 300, height: 50, alignment: .leading)



    }
}

//#Preview {
//    var order: Order!
//    NavigationStack    {
//
//        OrderCell(order: .init())
//    }
//    .environmentObject(ProfileVM())
//}

//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderView: View {
    
    @State var user: Person
    @EnvironmentObject var pVM : ProfileVM

    var order: Order

    var body: some View {

            //        List {
            Spacer()

            Text("Display Order")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 10)

            VStack(alignment: .center) {

                ZStack(alignment: .top) {

                    VStack(alignment: .leading) {
                        Text("Your information")
                            .font(.body)
                            .foregroundColor(.tmdText)
                            .padding(.horizontal, 20)

                        HStack {

                            Text(order.senderFirstName ?? "")
                                .padding(.horizontal)
                                .frame(width: 170, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.tmdText)
                                .cornerRadius(10)
                                .padding(.vertical, 2)

                            Text(order.senderLastName ?? "")
                                .padding(.horizontal)
                                .frame(width: 170, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.tmdText)
                                .cornerRadius(10)
                                .padding(.vertical, 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        Text("Sender's ID: \(user.userId)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.vertical, 2)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }

                ZStack {
                    Rectangle()
                        .fill(order.orderStatus == "Active" ? Color.blue : Color.gray)
                        .frame(height: 240)
                        .padding(-15)

                    VStack {
                        Text("Recipient information")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)
                            .font(.body)
                            .foregroundColor(.white)

                        VStack(alignment: .center) {

 
                            HStack {
                                Text(order.receiverFirstName ?? ""
                                )
                                .padding(.horizontal)
                                .frame(width: 170, height: 50)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding(.vertical, 5)

                                Text(order.receiverLastName ?? ""
                                )
                                .padding(.horizontal)
                                .frame(width: 170, height: 50)
                                .background(
                                    Color.white
                                )
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding(.vertical, 5)

                            }

                            Text(order.receiverEmail ?? ""
                            )
                            .textInputAutocapitalization(.never)
                            .padding(.horizontal)
                            .frame(width: 350, height: 50)
                            .background(
                                Color.white
                            )
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                        }
                        .padding(.horizontal, 10)

                        Text("Recipient's ID: \(String(describing: order.receiverId))")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)
                    }
                }

                if (order.orderStatus == "Expired") {
                    Text("THIS ORDER HAS EXPIRED.")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                } else {
                    Text("This order is active and will expire on 5/15/2025.")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                        .padding(.top, 30)
                }
                
                Text("Order ID: \(order.orderId)")
                    .font(.caption)
                  
                Spacer()
            }



    }
}

//#Preview {
//    var order: Order
//
//    NavigationStack {
//        OrderView(user: Person(userId: ""), order: order)
//    }
//
//}

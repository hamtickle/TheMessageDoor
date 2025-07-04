//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderView: View {
    
    var k: Constants = Constants()
    var user: Person
    var order: Order
    @Binding var tabSelection: Int
    var vm: OrderVM
    @State var orderExpired: Bool = false
    @State var renewal: Bool = false
    @State private var isPressed = false
    
    var body: some View {

// MARK: Order header
        
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
                        
                    
                        if k.showIds {
                            Text("Sender's ID: \(user.userId)")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2)
                        }
                       
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }
                
// MARK: Recipient Details

                ZStack {
                    Rectangle()
                        .fill(orderExpired ? Color.gray : Color.blue)
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

                            Text(order.receiverEmail
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
                            
                            
                            HStack {
                                Text("Order Created: ")
                                    .font(.caption)
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
//                                    .padding(.vertical, 5)
                                
                                Text(order.orderDateCreated,
                                    format: Date.FormatStyle(date: .numeric))
                                .font(.caption)
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
//                                    .padding(.vertical, 5)
                            }
                            .frame(width: 210)
                            
                            HStack {
                                Text("Order Type: ")
                                    .font(.caption)
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
//                                    .padding(.vertical, 5)
                                
                                Text(order.orderType ?? "")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
    //                                .padding(.vertical, 5)
                            }
                            .frame(width: 230)
                            
                            HStack {
                                Text(renewal ? "Order Renewal:" : "Order Expiration: ")
                                    .font(.caption)
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
//                                    .padding(.vertical, 5)
                                
                                Text(order.orderExpirationDate,
                                    format: Date.FormatStyle(date: .numeric))
                                .font(.caption)
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
//                                    .padding(.vertical, 5)
                            }
                            .frame(width: 230)

                        }
                        .padding(.horizontal, 10)
                        if k.showIds    {
                            Text("Order ID: \(order.orderId)")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                        }
                        
                    }
                }
                
// MARK: Order Footer

                if (orderExpired) {
                    Text("THIS ORDER HAS EXPIRED.")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                } else {
                    Text(renewal ? "This order is \(order.orderStatus) and will renew on" : "This order is \(order.orderStatus) and will expire on")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)
                        .padding(.top, 30)
                    Text(order.orderExpirationDate,
                         format: Date.FormatStyle(date: .numeric))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
//                        .padding(.top, 30)
                }
                
//  Cancelation button for Subscription Orders
                if order.orderType == k.typeMonthly {
                    Button(action: {
                        
// insert cancelation logic here

                    }) {
                        Text("Cancel Renewal")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                    .opacity(isPressed ? 0.6 : 1.0)
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                    .pressEvents {
                        withAnimation(.easeIn(duration: 0.2)) {
                            isPressed = true
                        }
                    } onRelease: {
                        withAnimation {
                            isPressed = false
                        }
                    }
                          
                }
                  
                Spacer()
            }
            .onAppear {
                tabSelection = 2
                if order.orderExpirationDate < Date() {
                    orderExpired = true
                } else {
                    orderExpired = false
                }
                if order.orderType == k.typeMonthly {
                    renewal = true
                } else {
                    renewal = false
                }
           
            }
         
                



    }
}

#Preview {
//    var order: Order = Order(from: any Decoder)

    NavigationStack {
        OrderView(user: Person(userId: ""), order: Order(orderId: "123"), tabSelection: .constant(2), vm: OrderVM())
    }

}

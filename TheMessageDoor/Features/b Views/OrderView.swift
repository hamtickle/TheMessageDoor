//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var pVM = ProfileViewModel()
    @StateObject private var oVM = OrderViewModel()

    @State var receiverList: [String] = [
        "New Recipient"
    ]

    @Binding var currentReceiver: String

    var newReceiver: Profile? = nil

    var body: some View {

        //        List {
        Spacer()

        Text("Create Order")
            .font(.system(size: 34, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 30)

        VStack(alignment: .center) {

            ZStack(alignment: .top) {

                VStack(alignment: .leading) {
                    Text("Your information")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)

                    HStack {

                        Text(pVM.currentUserFirstName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 2)

                        Text(pVM.currentUserLastName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Text("UserID: \(pVM.currentUserId)")
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
                    .fill(Color.blue)
                    .frame(height: 330)
                    .padding(-15)

                VStack {
                    Text("Recipient information")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40)
                        .font(.body)
                        .foregroundColor(.white)

                    VStack(alignment: .center) {

                        HStack {
                            Text("Recipient:")

                            Picker(
                                "",
                                selection: $oVM.currentReceiverEmail
                            ) {
                                ForEach(receiverList, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                                .frame(width: 225, height: 60)
                                .padding(.vertical, -15)
                                .padding(.horizontal, -10)
                        }
                        .frame(width: 330, height: 75)
                        .background(Color.white)
                        .border(Color.blue, width: 2)

                        TextField(
                            "recipient first:",
                            text: $oVM.currentReceiverFirstName
                        )
                        .padding(.horizontal)
                        .frame(width: 330, height: 50)
                        .background(
                            Color.white
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding(.vertical, 5)
                        )
                        TextField(
                            "recipient Last:",
                            text: $oVM.currentReceiverLastName
                        )
                        .padding(.horizontal)
                        .frame(width: 330, height: 50)
                        .background(
                            Color.white
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical, 5)
                        )
                        TextField(
                            "recipient email:", text: $oVM.currentReceiverEmail
                        )
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .frame(width: 330, height: 50)
                        .background(
                            Color.white
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical, 5)
                        )
                    }
                    .padding(.horizontal, 10)

                    Text("UserID: \(oVM.currentReceiverId)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding(.vertical, 2)

                }
            }

            Button(action: {
                // Add Recipient
                if oVM.currentReceiverEmail == "New Recipient" {
                    var receiverId = UUID().uuidString

                    pVM.createReceiver(
                        userId: receiverId,
                        email: oVM.currentReceiverEmail,
                        firstName: oVM.currentReceiverFirstName,
                        lastName: oVM.currentReceiverLastName,
                        myFont: "",
                        mySignature: ""
                    )
                    oVM.currentReceiverId = receiverId
                }

                var receiverId = oVM.currentReceiverId

                oVM.createOrder(
                    senderId: pVM.currentUserId,
                    senderFirstName: pVM.currentUserFirstName,
                    senderLastName: pVM.currentUserLastName,
                    receiverId: receiverId,
                    receiverEmail: oVM.currentReceiverEmail,
                    receiverFirstName: oVM.currentReceiverFirstName,
                    receiverLastName: oVM.currentReceiverLastName
                )
            }) {
                Text("Create Order")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            .padding(.top, 20)
            Spacer()
        }

        .onAppear {
            Task {
                try? await pVM.loadCurrentUser()
                try? await oVM.getReceivers(senderId: pVM.currentUserId)
                receiverList.append(contentsOf: oVM.receiverList)
                print("Final ReceiverList: \(receiverList)")

            }
        }
        .onChange(of: oVM.currentReceiverEmail) {
            oVM.getReceiverProperties(receiverEmail: oVM.currentReceiverEmail)
            //print("x: \(x), y: \(y), z: \(z)")
            oVM.currentReceiverId = oVM.thisReceiverId
            oVM.currentReceiverFirstName = oVM.thisReceiverFirst
            oVM.currentReceiverLastName = oVM.thisReceiverLast
            print("First: \(oVM.thisReceiverFirst)")
        }

        .padding(.bottom, 100)
        .navigationTitle(Text("Create Order"))
    }
}

#Preview {

    NavigationStack {
        OrderView(currentReceiver: .constant(""))
    }

}

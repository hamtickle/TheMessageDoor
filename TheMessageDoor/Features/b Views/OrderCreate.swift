//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct OrderCreate: View {
    @StateObject private var pVM = ProfileViewModel()
    @StateObject private var oVM = OrderViewModel()

    @State var receiverList: [String] = [""]

    var newReceiver: Profile? = nil

    var body: some View {

        //        List {
        Spacer()

        Text("Create Order")
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

                        Text(pVM.currentUserFirstName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.tmdText)
                            .cornerRadius(10)
                            .padding(.vertical, 2)

                        Text(pVM.currentUserLastName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.tmdText)
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Text("Sender's ID: \(pVM.currentUserId)")
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
                    .frame(height: 280)
                    .padding(-15)

                VStack {
                    Text("Recipient information")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                        .font(.body)
                        .foregroundColor(.white)

                    VStack(alignment: .center) {

                        HStack {
                            Text("Recipient:")
                                .foregroundColor(.black)

                            Picker(
                                "",
                                selection: $oVM.selectedReceiverEmail
                            ) {
                                ForEach(receiverList, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                                .frame(width: 225, height: 60)
                                .padding(.vertical, -15)
                                .padding(.horizontal, -10)
                        }
                        .frame(width: 350, height: 75)
                        .background(Color.white)
                        .border(Color.blue, width: 2)

                        HStack {
                            TextField("recipient first:",
                                text: $pVM.currentReceiverFirst
                            )
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                            TextField(
                                "recipient last:",
                                text: $pVM.currentReceiverLast
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

                        TextField(
                            "recipient email:", text: $pVM.currentReceiverEmail
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

                    Text("Recipient's ID: \(pVM.currentReceiverId)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.vertical, 2)
                }
            }

            Button(action: {
                
                
                // Add Recipient
                if oVM.selectedReceiverEmail == "New Recipient" {
                    let receiverId = UUID().uuidString
                    pVM.currentReceiverId = receiverId

                   do {
                        Task {
                            try await pVM.createReceiver(
                                userId: receiverId,
                                email: pVM.currentReceiverEmail,
                                firstName: pVM.currentReceiverFirst,
                                lastName: pVM.currentReceiverLast,
                                myFont: "Arial",
                                mySignature: "no signature on file"

                            )
                       }
                    }
                    
              

                }  // end if new receiver

                oVM.createOrder(
                    senderId: pVM.currentUserId,
                    senderFirstName: pVM.currentUserFirstName,
                    senderLastName: pVM.currentUserLastName,

                    receiverId: pVM.currentReceiverId,
                    receiverEmail: pVM.currentReceiverEmail,
                    receiverFirstName: pVM.currentReceiverFirst,
                    receiverLastName: pVM.currentReceiverLast
                )

                // after creating order, reset the form

                oVM.selectedReceiverEmail = "New Recipient"

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
                receiverList.removeAll()
                receiverList.append("New Recipient")
                receiverList.append(contentsOf: oVM.receiverList)

            }
        }
        .onChange(of: oVM.selectedReceiverEmail) {

            if oVM.selectedReceiverEmail == "New Recipient" {
                pVM.currentReceiverId = ""
                pVM.currentReceiverFirst = ""
                pVM.currentReceiverLast = ""
                pVM.currentReceiverEmail = ""
            } else {
                do {
                    Task {
                        try await pVM.getReceiver(
                            email: oVM.selectedReceiverEmail)
                    }
                }
            }
        }
        .alert(
            isPresented: $oVM.updateOrderSuccessful,
            content: {
                Alert(
                    title: Text("Order Created"),
                    message: Text("Your order has been created. Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )

//        .padding(.bottom, 100)
        .navigationTitle(Text("Create Order"))
    }
}

#Preview {

    NavigationStack {
        OrderCreate()
    }

}

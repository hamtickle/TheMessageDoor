//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct OrderCreate: View {

    var k: Constants = Constants()
    @State var currentUser: Person
    @StateObject var ovm = OrderCreateVM()

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>

    @State var receiverList: [String] = [""]

    var newReceiver: Profile? = nil
    @State private var isPressed = false
    @Binding var noOrders: Bool
    @State var selectedOrderType: String = ""
    @State private var loading: Bool = false

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

                        Text(currentUser.firstName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.tmdText)
                            .cornerRadius(10)
                            .padding(.vertical, 2)

                        Text(currentUser.lastName)
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.tmdText)
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Text("Sender's ID: \(currentUser.userId)")
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
                                selection: $ovm.selectedReceiverEmail
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
                            TextField(
                                "",
                                text: $ovm.currentReceiverFirstName,
                                prompt: Text("first name...").foregroundColor(
                                    .gray
                                ).font(.body)
                            )
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .disableAutocorrection(true)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                            TextField(
                                "recipient last:",
                                text: $ovm.currentReceiverLastName,
                                prompt: Text("last name...").foregroundColor(
                                    .gray
                                ).font(.body)
                            )
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .disableAutocorrection(true)
                            .background(
                                Color.white
                            )
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                        }

                        TextField(
                            "recipient email:", text: $ovm.currentReceiverEmail,
                            prompt: Text("email...").foregroundColor(.gray)
                                .font(.body)
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
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

                }
            }

            SelectOrderType(selectedOrderType: selectedOrderType)

            Button(action: {

                ovm.createOrderButtonTapped(
                    user: currentUser, first: ovm.currentReceiverFirstName,
                    last: ovm.currentReceiverLastName,
                    email: ovm.currentReceiverEmail)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.presentationMode.wrappedValue.dismiss()
                }

            }) {
                Text("Create Order")
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
            .padding(.top, 20)

            Button(action: {

                noOrders = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.presentationMode.wrappedValue.dismiss()
                }

            }) {
                Text("Cancel")
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
            Spacer()

                .onAppear {
                    loading = true
                    Task {
                        try? await ovm.getReceivers(
                            senderId: currentUser.userId)
                        receiverList.removeAll()
                        receiverList.append("New Recipient")
                        receiverList.append(contentsOf: ovm.receiverList)
                        ovm.selectedReceiverEmail = receiverList[0]
                        // get order types
                        let blankOrderType = OrderType(
                            orderTypeId: "", type: "Select Order Type",
                            price: 0.0,
                            description:
                                "Please select an order type from the options available.",
                            minDuration: 0)
                        ovm.orderTypes.append(blankOrderType)
                        try? await ovm.getOrderTypes()
                        loading = false
                    }

                }
                .onChange(of: ovm.selectedReceiverEmail) {

                    if ovm.selectedReceiverEmail == "New Recipient" {
                        ovm.currentReceiverFirstName = ""
                        ovm.currentReceiverLastName = ""
                        ovm.currentReceiverEmail = ""
                    } else {

                        ovm.getReceiverInfo(email: ovm.selectedReceiverEmail)
                    }
                }

                .alert(
                    isPresented: $ovm.updateOrderSuccessful,
                    content: {
                        Alert(
                            title: Text("Order Created"),
                            message: Text(
                                "Your order has been created. \n Thank You."),
                            dismissButton: .cancel(Text("OK")))
                    }
                )
                .alert(
                    isPresented: $ovm.duplicateOrders,
                    content: {
                        Alert(
                            title: Text("Active Order Exists"),
                            message: Text(
                                "You have an active order for \n \(ovm.selectedReceiverEmail). \n Please complete existing order first."
                            ),
                            dismissButton: .cancel(Text("OK")))
                    }
                )
                .overlay {
                    if loading {
                        ProgressView()
                    }
                }
            //                .environmentObject(OrderCreateVM())
            //        .navigationTitle(Text("Create Order"))

        }

    }

    struct SelectOrderType: View {
        @StateObject var ovm = OrderCreateVM()
        @State var selectedOrderType: String = ""
        @State var typeIndex: Int = 0

        //        init(selectedOrderType: Binding<String>) {
        //            _ovm = StateObject(wrappedValue: OrderCreateVM())
        //        }

        var body: some View {
            HStack {
                Text("Order Type:")
                Picker(
                    "",
                    selection: $selectedOrderType
                ) {
                    ForEach(ovm.orderTypeList, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.menu)
                    .frame(width: 225, height: 60)
                    .padding(.vertical, -15)
                    .padding(.horizontal, -10)
            }
            .frame(width: 350, height: 75)
            .border(Color.blue)
            .padding(.vertical, 20)

            HStack(alignment: .top) {
                Text("Description:")
                    .font(.caption)
                Text(ovm.orderTypes[typeIndex].description)
                    .font(.caption)
                    .frame(width: 250)
                    .lineLimit(nil)
            }
            .padding(.bottom, 10)

            HStack {
                Text("Price: $")
                Text(
                    ovm.orderTypes[typeIndex].price,
                    format: .currency(code: "USD"))
            }

            .onChange(of: selectedOrderType) {
                // lookup index of OrderType
                let index = ovm.orderTypeList.firstIndex {
                    $0 == selectedOrderType
                }

                if let index = index {
                    typeIndex = index
                }

            }
            .onAppear {

                Task {
                    try await ovm.getOrderTypes()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    selectedOrderType = ovm.orderTypeList[0]
                }

            }

        }

    }

}

#Preview {

    NavigationStack {
        OrderCreate(currentUser: Person(userId: ""), noOrders: .constant(true))
    }

}

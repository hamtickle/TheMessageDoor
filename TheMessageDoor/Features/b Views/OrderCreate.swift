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
    @ObservedObject var ovm: OrderVM
    @Binding var tabSelection: Int

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

// MARK: Order Header

        Spacer()

        Text("Create Order")
            .font(.system(size: 34, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 10)

        VStack(alignment: .center) {
            if k.showIds {
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
            }

// MARK: Recipient Details

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

// MARK: Order Type Selector

            SelectOrderType(ovm: ovm, selectedOrderType: $selectedOrderType)

// MARK: Buttons

            Button(action: {

                tabSelection = 2

                ovm.createOrderButtonTapped(
                    user: currentUser,
                    first: ovm.currentReceiverFirstName,
                    last: ovm.currentReceiverLastName,
                    email: ovm.currentReceiverEmail,
                    orderType: selectedOrderType)

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
                tabSelection = 2

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

// MARK: OnAppear

                .onAppear {
                    loading = true
                    tabSelection = 2
                    Task {
                        receiverList.removeAll()
                        receiverList.append(k.newRecipient)
                        receiverList.append(contentsOf: ovm.receiverList)
                        ovm.selectedReceiverEmail = receiverList[0]
                        loading = false
                    }

                }
                .onChange(of: ovm.selectedReceiverEmail) {

                    if ovm.selectedReceiverEmail == k.newRecipient {
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
                                k.orderCreated),
                            dismissButton: .cancel(Text("OK")))
                    }
                )
                .alert(
                    isPresented: $ovm.duplicateOrders,
                    content: {
                        Alert(
                            title: Text("Active Order Exists"),
                            message: Text(
                                k.orderDuplicate
                            ),
                            dismissButton: .cancel(Text("OK")))
                    }
                )
                .overlay {
                    if loading {
                        ProgressView()
                    }
                }
        }
    }
}

#Preview {

    NavigationStack {
        OrderCreate(
            currentUser: Person(userId: ""), ovm: OrderVM(),
            tabSelection: .constant(2), noOrders: .constant(true))
    }

}

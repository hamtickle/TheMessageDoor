//
//  OrderView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/7/25.
//

import SwiftUI

struct OrderCreate: View {
    
    @StateObject var pVM : ProfileViewModel
    @StateObject var vm = OrderCreateVM()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var receiverList: [String] = [""]

    var newReceiver: Profile? = nil
    @State private var isPressed = false

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
                                selection: $vm.selectedReceiverEmail
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
                            TextField("",
                                      text: $vm.currentReceiverFirstName,
                                      prompt: Text("first name...").foregroundColor(.gray).font(.body)
                            )
                            .padding(.horizontal)
                            .frame(width: 170, height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.vertical, 5)

                            TextField(
                                "recipient last:",
                                text: $vm.currentReceiverLastName,
                                prompt: Text("last name...").foregroundColor(.gray).font(.body)
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
                            "recipient email:", text: $vm.currentReceiverEmail,
                            prompt: Text("email...").foregroundColor(.gray).font(.body)
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

                    Text("Recipient's ID: \(vm.currentReceiverId)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.vertical, 2)
                }
            }

            Button(action: {
                
                
                // Add Recipient
                if vm.selectedReceiverEmail == "New Recipient" {
                    let receiverId = UUID().uuidString
                    vm.currentReceiverId = receiverId

                   do {
                        Task {
                     try await vm.createReceiver(
                                userId: receiverId,
                                email: vm.currentReceiverEmail,
                                firstName: vm.currentReceiverFirstName,
                                lastName: vm.currentReceiverLastName,
                                myFont: "Arial",
                                mySignature: "no signature on file"

                            )
                       }
                   }  

                }   //end if new receiver

                //check for duplicate orders
                vm.checkIfActiveOrderExists(email: vm.currentReceiverEmail)
                
                if vm.duplicateOrders
                    {
                    print("order already exists")
                } else {
                    vm.createOrder(
                        senderId: pVM.currentUserId,
                        senderFirstName: pVM.currentUserFirstName,
                        senderLastName: pVM.currentUserLastName,

                        receiverId: vm.currentReceiverId,
                        receiverEmail: vm.currentReceiverEmail,
                        receiverFirstName: vm.currentReceiverFirstName,
                        receiverLastName: vm.currentReceiverLastName
                    )
                    
                    vm.selectedReceiverEmail = "New Recipient"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
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
            Spacer()
        }

        .onAppear {
            Task {
                try? await vm.getReceivers(senderId: pVM.currentUserId)
                receiverList.removeAll()
                receiverList.append("New Recipient")
                receiverList.append(contentsOf: vm.receiverList)

            }
        }
        .onChange(of: vm.selectedReceiverEmail) {

            if vm.selectedReceiverEmail == "New Recipient" {
                vm.currentReceiverId = ""
                vm.currentReceiverFirstName = ""
                vm.currentReceiverLastName = ""
                vm.currentReceiverEmail = ""
            } else {

                vm.getReceiverInfo(email: vm.selectedReceiverEmail)
            }
        }
        .alert(
            isPresented: $vm.updateOrderSuccessful,
            content: {
                Alert(
                    title: Text("Order Created"),
                    message: Text("Your order has been created. \n Thank You."),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .alert(
            isPresented: $vm.duplicateOrders,
            content: {
                Alert(
                    title: Text("Active Order Exists"),
                    message: Text("You have an active order for \n \(vm.selectedReceiverEmail). \n Please complete existing order first."),
                    dismissButton: .cancel(Text("OK")))
            }
        )


        .navigationTitle(Text("Create Order"))
        

    }
}

#Preview {

    NavigationStack {
        OrderCreate(pVM: ProfileViewModel())
    }

}

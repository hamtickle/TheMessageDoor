//
//  RecipientPicker.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/9/25.
//
import SwiftUI

struct RecipientPicker: View {
    
    @StateObject var user: GetCurrentUser
    @StateObject var vm: MessageCreateVM
    
//    @Binding var currentReceiverId: String
//    @State var currentReceiverEmail: String
//    @State var to: String

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode:
    Binding<PresentationMode>
 
    @State var receiverList: [String] = []
    
    init(vm: MessageCreateVM) {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
//        _vm = StateObject(wrappedValue: MessageCreateVM())
        _vm = StateObject(wrappedValue: vm)
    }

   
    
    var body: some View {
        HStack {
            Text("My Recipients:")
                .foregroundColor(.black)
            
            Picker(
                "",
                selection: $vm.selectedReceiverEmail
            ) {
                Text("").tag("")
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Task {
                    print("\n user: \(user.currentUser)")
                    print("getReceivers: \(user.currentUser.userId)")
                    
                    try? await vm.getReceivers(senderId: user.currentUser.userId)

                    receiverList.removeAll()
                    receiverList.append(contentsOf: vm.receiverList)
                    if receiverList.isEmpty {
                        receiverList.append(contentsOf: ["No Recipients Found"])
                    }
                    print(receiverList.count)
                    vm.selectedReceiverEmail = receiverList.first ?? ""
                    
                    vm.getReceiverInfo(email: vm.selectedReceiverEmail)
                }
            }
        }
        .onChange(of: vm.selectedReceiverEmail) {
            
            vm.getReceiverInfo(email: vm.selectedReceiverEmail)

        }
        
    }
}

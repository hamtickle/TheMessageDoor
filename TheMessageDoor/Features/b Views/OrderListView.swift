//
//  OrderListView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/13/25.
//

import SwiftUI

struct OrderListView: View {

    var k: Constants = Constants()
    @StateObject var user: GetCurrentUser
    @StateObject var vm: OrderVM
    @Binding var tabSelection: Int

    @Environment(\.colorScheme) var colorScheme
    @State private var loading: Bool = false
    @State var orderFilter = 0

    init(tabSelection: Binding<Int>) {
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = StateObject(wrappedValue: OrderVM())
        _tabSelection = tabSelection
    }

    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                Text("\(user.currentUser.firstName)'s Orders")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                NavigationLink {
                    OrderCreate(
                        currentUser: user.currentUser, ovm: vm, tabSelection: $tabSelection, noOrders: $vm.noOrders)
                } label: {
                    Image(systemName: "cart")
                        .font(.system(size: 20))
                        .foregroundColor(
                            colorScheme == .dark ? Color.blue : Color.blue
                        )
                        .padding(.trailing, 10)
                }

            }
            .padding(.top, 30)
            
            Picker("Filter", selection: $orderFilter) {
                Text("Active Orders").tag(0)
                Text("All Orders").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            List(vm.orderList, id: \.orderId) { order in
                NavigationLink(
                    destination: OrderView(user: user.currentUser, order: order, tabSelection: $tabSelection, vm: vm)
                ) {
                    HStack(alignment: .top) {
                        OrderCell(order: order, vm: vm)
                            .frame(width: 300)
                        //                            .padding(.vertical, 0)
                        //                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Your Orders"))
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .onAppear{
            tabSelection = 2
        }
        
        .onChange(of: orderFilter) { oldValue, newValue in
            if newValue == 0 {
                do {
                    vm.orderList.removeAll()
                    vm.orderList = vm.activeOrders
                }
            } else {
                do {
                    vm.orderList.removeAll()
                    vm.orderList = vm.allOrders
                }
            }
        }
     
        
        .task {
            loading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                _ = user.currentUser
//                print("OLV appUser: \(appUser) \n")

                loading = false
            }
        }
        //        .alert(
        //            isPresented: $vm.noOrders,
        //            content: {
        //                Alert(
        //                    title: Text("No Active Orders"),
        //                    message: Text(
        //                        "You do not have any ACTIVE orders.  \n Please create an order so you can send messages."
        //                    ),
        //                    dismissButton: .cancel(Text("OK"))
        //                )
        //            })
        .fullScreenCover(isPresented: $vm.noOrders) {
            NavigationStack {
                OrderCreate(
                    currentUser: user.currentUser, ovm: vm, tabSelection: $tabSelection, noOrders: $vm.noOrders)
            }
        }
    }

}

#Preview {
    NavigationStack {
        OrderListView(tabSelection: .constant(2))
    }

}

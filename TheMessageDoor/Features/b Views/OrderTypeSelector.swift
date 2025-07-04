//
//  OrderTypeSelector.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 6/30/25.
//

import SwiftUI

// MARK: Select Order Type View

struct SelectOrderType: View {
    @ObservedObject var ovm: OrderVM
    @Binding var selectedOrderType: String
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
                .lineLimit(4)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedOrderType = ovm.orderTypeList[0]
            }
        }
    }
}

#Preview {
    SelectOrderType(ovm: OrderVM(), selectedOrderType: .constant("Annual"))
}

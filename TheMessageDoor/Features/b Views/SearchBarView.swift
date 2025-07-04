//
//  SearchBarView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 6/29/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @ObservedObject var vm: MessageVM
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(vm.searchText.isEmpty ? Color.gray : Color.black)
            
            TextField("Search for a text in a message...", text: $vm.searchText)
                .foregroundColor(colorScheme == .dark
                                 ? Color.gray : Color.black)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.black)
                        .opacity(vm.searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            vm.searchText = ""
                            vm.restoreMessages()}
                  ,   alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            Rectangle()
                .fill(Color.white)
        )
        .padding()
    }
}

#Preview {
    
    Group {
        SearchBarView(vm: MessageVM())
            
            .preferredColorScheme(.light)
        
        SearchBarView(vm: MessageVM())
   
            .preferredColorScheme(.dark)
    }
}

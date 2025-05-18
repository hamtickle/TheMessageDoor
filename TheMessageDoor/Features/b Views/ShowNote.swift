//
//  ShowNote.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/9/25.
//
import SwiftUI

struct ShowNote: View {

    var k: Constants = Constants()
    @StateObject var vm: MessageCreateVM
    @StateObject private var fonts = Fonts()
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        ZStack {

            Rectangle()
                .fill(Color(.yellow))
                .frame(width: 350, height: 305)
                .shadow(
                    color: colorScheme == .dark ? Color.gray : Color.black,
                    radius: 10, x: 10, y: 10)

            VStack(alignment: .trailing) {
                Rectangle()
                    .fill(Color(.yellow))
                    .frame(width: 350, height: 20)
                //                    Text("message")
                TextEditor(text: $vm.currentMessage)
                    .font(.custom(vm.messageFont, size: vm.fontSize))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                    .scrollContentBackground(.hidden)
                    .frame(width: 350, height: 190)
                    .background(Color(.yellow))
                Image(_: "signature no background")
                    .resizable()
                    .frame(width: 100, height: 80)
                    .scaledToFit()
                    .frame(alignment: .bottomTrailing)
            }

        }
        .padding(.bottom, 20)
//        .onChange (of: vm.messageFont) {
//            let font = vm.messageFont
//            fontSize = fonts.getFontSize(font: font)
//        }
//        .onAppear {
//            let font = vm.messageFont
//            fontSize = fonts.getFontSize(font: font)
//        }
    }
                  
}

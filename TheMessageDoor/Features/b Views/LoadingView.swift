//
//  LoadingView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 6/22/25.
//

import SwiftUI

struct LoadingView: View {

    @ObservedObject var vm: MessageVM
    @ObservedObject var user: GetCurrentUser

    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme

    let columns: [GridItem] = [
        GridItem(.fixed(30), spacing: nil, alignment: nil),
        GridItem(.fixed(30), spacing: nil, alignment: nil),
        GridItem(.fixed(30), spacing: nil, alignment: nil),
        GridItem(.fixed(30), spacing: nil, alignment: nil),
        GridItem(.fixed(30), spacing: nil, alignment: nil),
    ]

    @State var isAnimated: Bool = false
    @State private var isPressed = false
    @State var messagesLoaded: Bool = false
    @State private var fadeOut = false
    @State private var backgroundColor = Color.yellow

    var body: some View {

        VStack {
            if messagesLoaded {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    VStack {
                        Text("Go To Your Door")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                    }

                }
                .font(.headline)
                .frame(width: 200, height: 50)
                .border(Color.blue)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(10)
                .padding(.vertical, 5)
                //                .transition(.opacity)

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
            } else {
                Text("Preparing Your Message Door")
                    .font(.headline)

                    .frame(width: 250, height: 50)
                    .border(Color.blue.opacity(0.0))
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                    .onAppear {
                        withAnimation(
                            Animation
                                .easeInOut(duration: 0.6)
                        ) {
                        }
                    }.opacity(fadeOut ? 0 : 1)

            }

            ZStack {
                Image("Logo_TMD_large")
                    .resizable()
                    .frame(width: 350, height: 650)
                VStack {

                    Rectangle()
                        .fill(Color.white.opacity(1.0))
                        .frame(width: 50, height: 200)
                    Rectangle()
                        .fill(Color.white.opacity(0.0))
                        .frame(height: 200)
                }
                VStack {

                    LazyVGrid(columns: columns) {
                        ForEach(0..<40) {
                            index in
                            Rectangle()
                                .fill(
                                    Color.yellow.opacity(
                                        self.isAnimated ? 1.0 : 0.0)
                                )
                                .frame(height: 30)
                                .animation(
                                    Animation.linear(
                                        duration: Double.random(in: 1.0...2.0)
                                    )
                                    .repeatForever(autoreverses: true)
                                    .delay(Double.random(in: 0...4.5)),
                                    value: isAnimated)

                        }
                    }
                    Rectangle()
                        .fill(Color.white.opacity(0.0))
                        .frame(height: 100)

                    Text("You have sent \(vm.senderMessages.count) messages")
                        .font(.caption)
                        .foregroundColor(messagesLoaded ? .black : .clear)
                    Text(
                        "You have received \(vm.receivedMessages.count) messages"
                    )
                    .font(.caption)
                    .foregroundColor(messagesLoaded ? .black : .clear)

                    Rectangle()
                        .fill(Color.white.opacity(0.0))
                        .frame(height: 60)

                }

                if vm.isUnread && messagesLoaded {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow.opacity(1.0))
                                .frame(width: 100, height: 100)
                                .shadow(
                                    color: colorScheme == .dark ? Color.gray : Color.black,
                                    radius: 10, x: 10, y: 10)
                            Text("You have \(vm.unReadMessages) new messages.")
                                .frame(
                                    width: 95, height: 95
                                )
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .foregroundColor(
                                    messagesLoaded ? .black : .clear)
                        }

                        Rectangle()
                            .fill(Color.white.opacity(0.0))
                            .frame(height: 140)
                    }

                }

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isAnimated = true
            }

            Task {
                print("Load Screen \(user.currentUser.email) \n")
                await vm.fetchReceiverMessages(to: user.currentUser.email)
                print("Load Screen \(user.currentUser.userId) \n")
                await vm.fetchSenderMessages(senderId: user.currentUser.userId)

            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                fadeOut = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                messagesLoaded = true
            }
        }

    }
}

#Preview {
    var messagesLoaded = false
    LoadingView(vm: MessageVM(), user: GetCurrentUser(initialLoad: true))
}

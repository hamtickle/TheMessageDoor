//
//  UserView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import SwiftUI

struct ProfileView: View {

    private var k: Constants = Constants()
    @StateObject var user: GetCurrentUser
    @ObservedObject var vm: ProfileVM
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var fonts = Fonts()
    

    @Binding var showSignInView: Bool
    @State var updateSuccessful: Bool = false
//    @State var incompleteProfile: Bool = false

    @FocusState private var isFocused: Bool

    @State var fontList: [String] = []
    @State var fontSize: CGFloat = 25
    @State private var isPressed = false

    init(showSignInView: Binding<Bool>) {
        print("init Profile View \n")
        _user = StateObject(wrappedValue: GetCurrentUser(initialLoad: false))
        _vm = ObservedObject(wrappedValue: ProfileVM())
        _showSignInView = showSignInView
        
    }

    var body: some View {
        ScrollView {

// MARK: Profile header
            
            Spacer()
            HStack {
                Text("Your Profile")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)

                NavigationLink(
                    destination: SettingsView(showSignInView: $showSignInView)
                ) {
                    Image(systemName: "gear")
                        .font(.system(size: 20))
                        .padding(.horizontal, 20)
                }
            }

            VStack(alignment: .center) {
                //            Spacer()

                //            List {
                //            if let _ = vm.user {

                VStack(alignment: .center) {
                    VStack(alignment: .center) {

                        HStack {
                            TextField(
                                "First", text: $vm.currentUser.firstName
                            )
                            .focused($isFocused)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .frame(
                                width: 170, height: 50, alignment: .center
                            )
                            .border(Color.blue)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)

                            TextField(
                                "Last", text: $vm.currentUser.lastName
                            )
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .frame(
                                width: 170, height: 50, alignment: .center
                            )
                            .border(Color.blue)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)
                        }
                        if k.showIds {
                            Text("UserID: \(vm.currentUser.userId)")
                                .font(.caption)
                                .foregroundColor(.tmdText)
                                .padding(.vertical, 2)
                        }
                      

                        HStack {
                            Text("First Door Opened: ")
                                .font(.caption)
                                .foregroundColor(.tmdText)
                                .padding(.vertical, 2)
                            Text(
                                "\(vm.currentUser.dateCreated.formatted(date: .numeric, time: .standard))"
                            )
                            .font(.caption)
                            .foregroundColor(.tmdText)
                            .padding(.vertical, 2)
                        }

                        TextField("email", text: $vm.currentUser.email)
                            .textInputAutocapitalization(.never)
                            .multilineTextAlignment(.center)
                            .disableAutocorrection(true)
                            .padding(.horizontal)
                            .frame(
                                width: 350, height: 50, alignment: .center
                            )
                            .border(Color.blue)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)

                    }
                    
// MARK: Font Selection
                    
                    HStack {
                        Text("My Font:")

                        Picker(
                            "",
                            selection: $vm.currentUser.myFont
                        ) {
                            ForEach(fontList, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.menu)
                            .frame(width: 200, height: 60)
                            .padding(.vertical, -15)
                    }
                    .frame(width: 370, height: 75)
                    .border(Color.blue)

                    ZStack {
                        Rectangle()
                            .fill(Color.yellow)
                            .frame(width: 370, height: 100)
                            .padding(5)
                            .shadow(
                                color: colorScheme == .dark
                                    ? Color.gray : Color.black,
                                radius: 10, x: 10, y: 10
                            )
                        Text(k.chooseFont)
                            .foregroundColor(.black)
                            .font(
                                .custom(
                                    vm.currentUser.myFont,
                                    size: fontSize
                            ))
                            .multilineTextAlignment(.center)
                            .frame(width: 350, height: 100)
                            .padding(.horizontal)

                    }
                }
                //                }
                
// MARK: Buttons

                VStack(alignment: .center) {

                    // Button to update User data here
                    Button {
                        updateSuccessful = true
                        vm.updateUser(
                            email: vm.currentUser.email,
                            firstName: vm.currentUser.firstName,
                            lastName: vm.currentUser.lastName,
                            myFont: vm.currentUser.myFont, mySignature: "")
                        print(k.profileUpdated, vm.updateSuccessful)
                    } label: {
                        Text("Update Profile")
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(10)
                    .padding(.vertical, 5)

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


// MARK: Profile Stats

                    Text("Message Door Stats")
                        .font(.headline)
                        .foregroundColor(.tmdText)
                    HStack {
                        Text(
                            "Total Messages: \(vm.userStats.totalMessagesCreated)"
                        )
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                        Image(systemName: "sum")
                    }
                    HStack {
                        Text(
                            "Messages Sent: \(vm.userStats.totalMessagesSent)"
                        )
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                        Image(systemName: "paperplane")
                    }
                    HStack {
                        Text(
                            "My Favorite Messages: \(vm.userStats.totalMyFavorites)"
                        )
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    HStack {
                        Text(
                            "Recipient's Favorite Messages: \(vm.userStats.totalReceiverFavorites)"
                        )
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.blue)
                    }

                }
                .padding(.horizontal)
                Spacer()

            }
            
        }
        
//  MARK: OnAppear stuff
        
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                vm.fetchUserStats(userId: vm.currentUser.userId)
            }
        }
        .onChange(of: vm.currentUser.myFont) {
            let font = vm.currentUser.myFont
            fontSize = fonts.getFontSize(font: font)
        }
        
        
        .alert(
            isPresented: $vm.incompleteProfile,
            content: {
                Alert(
                    title: Text("Incomplete Profile"),
                    message: Text(
                        k.profileIncomplete
                    ),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
        .alert(
            isPresented: $vm.updateSuccessful,
            content: {
                Alert(
                    title: Text("Profile Updated"),
                    message: Text(
                        k.profileUpdated
                    ),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if vm.currentUser.lastName == "" {
                    self.isFocused = true
                }
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)

            }
            // Current User Data from User Defaults
            vm.fetchUserDefaults()
        }
        .onTapGesture {
            self.endTextEditing()
        }

    }

}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(true))
    }
}

//
//  UserView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import SwiftUI

struct ProfileView: View {

    @State var user: Person
    @EnvironmentObject var vm : ProfileViewModel
//    @State var currentUser = GetCurrentUser.shared
  
    
    @StateObject private var fonts = Fonts()

    @Binding var showSignInView: Bool
    @State var updateSuccessful: Bool = false
    @State var incompleteProfile: Bool = false

    @FocusState private var isFocused: Bool
    
    @State var fontList: [String] = []
    @State private var isPressed = false

    var body: some View {
        
        Spacer()
        
        HStack {
            Text("Your Profile")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 10)
            
            NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
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
                                .frame(
                                    width: 170, height: 50, alignment: .center
                                )
                                .border(Color.blue)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding(.vertical, 2)
                            }
                            Text("UserID: \(vm.currentUser.userId)")
                                .font(.caption)
                                .foregroundColor(.tmdText)
                                .padding(.vertical, 2)

                            
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
                                .padding(.horizontal)
                                .frame(
                                    width: 350, height: 50, alignment: .center
                                )
                                .border(Color.blue)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding(.vertical, 2)
                            
                        }
                        
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
                        .frame(width: 350, height: 75)
                        .border(Color.blue)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(height: 100)
                                .padding(5)
                                .shadow(
                                    color: Color.black, radius: 10, x: 10, y: 10
                                )
                            Text("Choose the font you want for your messages.")
                                .foregroundColor(.black)
                                .font(.custom(vm.currentUser.myFont, size: (vm.currentUser.myFont == "Zapfino") ? 15 : 25))
                                .multilineTextAlignment(.center)
                                .frame(height: 100)
                                .padding(.horizontal)
                            
                        }
                    }
//                }
            
            
            VStack(alignment: .center) {

                // Button to update User data here
                Button {
                    vm.updateUser(
                        email: vm.currentUser.email,
                        firstName: vm.currentUser.firstName,
                        lastName: vm.currentUser.lastName,
                        myFont: vm.currentUser.myFont, mySignature: "")
                    updateSuccessful.toggle()
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
            

                // Profile Stats

                Text("Message Door Stats")
                    .font(.headline)
                    .foregroundColor(.tmdText)
                HStack {
                    Text("Total Messages: \(vm.currentUser.totalMessagesCreated)")
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                    Image(systemName: "sum")
                }
                HStack {
                    Text("Messages Sent: \(vm.currentUser.totalMessagesSent)")
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                    Image(systemName: "paperplane")
                }
                HStack {
                    Text("My Favorite Messages: \(vm.currentUser.totalMyFavorites)")
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("Recipient's Favorite Messages: \(vm.currentUser.totalReceiverFavorites)")
                        .font(.subheadline)
                        .foregroundColor(.tmdText)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.blue)
                }
                
                Text("myFont: \(vm.currentUser.myFont)")
                    .font(.caption)
                Text("mySignature: \(vm.currentUser.mySignature)")
                    .font(.caption)
                Text("URL: \(vm.currentUser.photoUrl)")
                    .font(.caption)
                Text("rKey: \(vm.currentUser.receiverKey)")
                    .font(.caption)
                
            }
            .padding(.horizontal)
            Spacer()
            
        }
        .navigationTitle("Your Profile")

        .alert(
            isPresented: $updateSuccessful,
            content: {
                Alert(
                    title: Text("Profile Updated"),
                    message: Text("Your profile was updated successfully!"),
                    dismissButton: .cancel(Text("OK")))
            }
        )
        .alert(
            isPresented: $incompleteProfile,
            content: {
                Alert(
                    title: Text("Incomplete Profile"),
                    message: Text("Your profile is incomplete. \n Please complete it before continuing."),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFocused = true
                fontList.removeAll()
                fontList.append(contentsOf: fonts.fonts)
            }
            // Current User Data from User Defaults
                vm.fetchUserDefaults()
        }

    }

}

#Preview {
    NavigationStack {
        ProfileView(user: Person(userId: ""), showSignInView: .constant(false))
    }
}




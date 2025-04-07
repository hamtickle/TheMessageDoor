//
//  UserView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import SwiftUI

struct ProfileView: View {

    //  @EnvironmentObject var pVM: PersonVM
    @StateObject private var pVM = ProfileViewModel()
    
    @Binding var showSignInView: Bool
    @State var updateSuccessful: Bool = false
    @FocusState private var isFocused: Bool

    @State var selectionOptions: [String] = [
        "Arial",
        "Copperplate",
        "Chalkduster",
        "Noteworthy",
        "SignPainter",
        "Snell Roundhand",
        "Times New Roman",
        "Zapfino",
    ]

    

    var body: some View {
        ZStack (alignment: .top) {
//            Rectangle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(maxWidth: .infinity)
//                .frame(height: 230)
//                .padding(-15)
            
            List {
                if let user = pVM.user {
                    VStack (alignment: .center) {
                        VStack(alignment: .center) {
                            
                            HStack {
                                TextField("First", text: $pVM.currentUserFirstName)
                                    .focused($isFocused)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 170, height: 50, alignment: .center)
                                    .border(Color.blue)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 2)
                                
                                TextField("First", text: $pVM.currentUserLastName)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 170, height: 50, alignment: .center)
                                    .border(Color.blue)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 2)
                            }
                            Text("UserID: \(user.userId)")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2)
                            
                            HStack {
                                Text("Date Created: ")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 2)
                                Text("\(pVM.currentUserDateCreated.formatted(date: .numeric, time: .standard))")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2)
                            }
                            
                            TextField("email", text: $pVM.currentUserEmail)
                            .textInputAutocapitalization(.never)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(width: 350, height: 50, alignment: .center)
                            .border(Color.blue)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)


                        }
                        
                        HStack {
                            Text("My Font:")
                            
                            Picker("",
                                   selection: $pVM.currentUserMyFont) {
                                ForEach(selectionOptions, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                                .frame(width: 200, height: 60)
                                .padding(.vertical, -15)
                        }
                        .frame(width: 350, height: 75)
                        .border(Color.blue)
                            

                        
                        ZStack()  {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(height: 100)
                                .padding(5)
                                .shadow(color: Color.black, radius: 10, x: 10, y: 10 )
                            Text("Choose the font you want for your messages?")
                                .foregroundColor(.black)
                                .font(.custom(pVM.currentUserMyFont, size: 25))
                                .multilineTextAlignment(.center)
                                .frame(height: 100)
                                .padding(.horizontal)
                            
                        }
                        
                        // Button to update User data here
                        Button {
                            pVM.updateUser(email: pVM.currentUserEmail, firstName: pVM.currentUserFirstName, lastName: pVM.currentUserLastName, myFont: pVM.currentUserMyFont, mySignature: "" )
                            updateSuccessful.toggle()
                        }
                        label: {
                            Text("Update Profile")
                        }
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                        
//                        Message Door Stats
                        
                        Text("Message Door Stats")
                            .font(.headline)
                            .foregroundColor(.primary)
                        HStack{
                            Text("Messages Sent: 100")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Image(systemName: "paperplane")
                        }
                        HStack{
                            Text("My Favorite Messages: 7")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        HStack{
                            Text("Recipient's Favorite Messages: 5")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                }
                   
                
            }
            .task {
                try? await pVM.loadCurrentUser()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Your Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {

                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
        .alert(isPresented: $updateSuccessful, content: {
            Alert(title: Text("Profile Updated"), message: Text("Your profile was updated successfully!"), dismissButton: .cancel(Text("OK") ))
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFocused = true
            }
        }
    }

}

#Preview {
    NavigationStack {
       
        ProfileView(showSignInView: .constant(false))

    }

}

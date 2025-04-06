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

    @State var username: String = ""

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

    @State var myFont: String = "Chalkduster"

    var body: some View {

        List {
            if let user = pVM.user {
                VStack() {
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: 230)
                            .padding(-15)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Your information")
                                .font(.body)
                                .foregroundColor(.black)
                            
                            HStack() {
                                
                                Text("first: \(user.firstName ?? "Brad")")
                                    .padding(.horizontal)
                                    .frame( height: 50)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.vertical, 2)
                                
                                Text("last: \(user.lastName ?? "Smith")")
                                    .padding(.horizontal)
                                    .frame( height: 50)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.vertical, 2)
                            }
                            Text("UserID: \(user.userId)")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.vertical,2)
                            
                            
                            Text("email: \(user.email ?? "brad.smith@test.com")")
                                .textInputAutocapitalization(.never)
                                .padding(.horizontal)
                                .frame( width: 280, height: 50)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding(.vertical,2)
                            
                            HStack() {
                                Text("Date Created: ")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .padding(.vertical,2)
                                Text(user.dateCreated!, format: Date.FormatStyle(date: .numeric))
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .padding(.vertical,2)
                            }
                            
                            
                        }
                        
                        // Button to update User data here
                        
                    }       // pVM.updateUser()
                    }
                    }
                }
        .task {
            try? await pVM.loadCurrentUser()
        }
        .navigationTitle("Welcome")
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
        }

    
}

#Preview {
    NavigationStack {

        ProfileView(showSignInView: .constant(true))

    }
    //    .environmentObject(PersonVM())
    //    .environmentObject(MessageVM())
    //    .environmentObject(OrderVM())
}

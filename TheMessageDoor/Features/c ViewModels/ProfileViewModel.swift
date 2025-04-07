//
//  ProfileViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: Profile? = nil
    @Published var currentUserEmail: String = ""
    @Published var currentUserFirstName: String = ""
    @Published var currentUserLastName: String = ""
    @Published var currentUserMyFont: String = ""
    @Published var currentUserDateCreated: Date = Date()
    @Published var currentUserPhotoUrl: String = ""
    @Published var currentUserMySignature: String = ""
    @Published var currentUserId: String = ""
    
    @Published var updateSuccessful: Bool = false
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult!.uid)
        unwrapUser()
    }
    
    func unwrapUser() {
        currentUserId = self.user?.userId ?? ""
        currentUserEmail = self.user?.email ?? ""
        currentUserFirstName = self.user?.firstName ?? ""
        currentUserLastName = self.user?.lastName ?? ""
        currentUserMyFont = self.user?.myFont ?? ""
        currentUserDateCreated = self.user?.dateCreated ?? Date()
        currentUserPhotoUrl = self.user?.photoUrl ?? ""
        currentUserMySignature = self.user?.mySignature ?? ""
       
    }
    
    
    func updateUser(email: String, firstName: String, lastName: String, myFont: String, mySignature: String) {
        guard let user else { return }
        
        let updatedUser = Profile(userId: user.userId, email: email, photoUrl: user.photoUrl, firstName: firstName, lastName: lastName, myFont: myFont, mySignature: ""  )
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
            updateSuccessful.toggle()
        }
    }
}

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
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult!.uid)
    }
    
    func updateUser() {
        guard let user else { return }
        
        let updatedUser = Profile(userId: user.userId, email: user.email, photoUrl: user.photoUrl, dateCreated: Date(), firstName: "David", lastName: "Smith", myFont: "Arial", mySignature: ""  )
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

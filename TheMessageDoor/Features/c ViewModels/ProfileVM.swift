//
//  ProfileVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
class ProfileVM: ObservableObject {

    private var k: Constants = Constants()

    @Published var currentUser: Person = Person(userId: "")
    @Published private(set) var user: Profile? = nil

    @Published var updateSuccessful: Bool = false
    @Published var incompleteProfile: Bool = false
    @Published var userStats: UserStats = UserStats(userId: "")

    init() {
    }
    
//
//  User Defaults functions
//
    
    func fetchUserDefaults() {
        
        // retrieve from UserDefaults
        guard
         let result = UserDefaults.standard.data(forKey: k.user),
         let currentUser = try? JSONDecoder().decode(Person.self, from: result)
        else { return }
        
        self.currentUser = currentUser
        
//        print("vm: \(self.currentUser)" )
        if self.currentUser.firstName == "" {
            incompleteProfile = true
        }
    }
    
    func fetchUserStats(userId: String) {
        Task {
            let result = try await StatManager.instance.getUserStats(senderId: userId)
             self.userStats = result
        }
       
    }
    
    func updateUserDefaults(person: Person) {
        if let encoded = try? JSONEncoder().encode(person) {
            UserDefaults.standard.set(encoded, forKey: k.user)
        }
    }
    
//    *********
    
    func updateUser(
        email: String, firstName: String, lastName: String, myFont: String,
        mySignature: String
    ) {


        let updatedUser = Profile(
            userId: currentUser.userId, email: currentUser.email, photoUrl: currentUser.photoUrl,
            firstName: currentUser.firstName, lastName: currentUser.lastName, myFont: currentUser.myFont,
            mySignature: k.appSignature, newUser: currentUser.newUser )
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(
                userId: currentUser.userId)

        }
        
        updateUserDefaults(person: currentUser)
        print("\n Profile Updated")
    }

    
}

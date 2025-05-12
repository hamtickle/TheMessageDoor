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

    func updateTotalMessageCount() {
        // update userDefaults
        currentUser.totalMessagesCreated += 1
        updateUserDefaults(person: currentUser)
    }
    
    func updateSentMessageCount() {
        // update userDefaults
        currentUser.totalMessagesSent += 1
        updateUserDefaults(person: currentUser)
    }
    
    func updateMyFavoritesCount() {
        currentUser.totalMyFavorites += 1
        updateUserDefaults(person: currentUser)
    }

    func updateReceiverFavoritesCount() {
        currentUser.totalReceiverFavorites += 1
        updateUserDefaults(person: currentUser)
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
//        guard let user else { return }
        
        // check if ReceiverKey has been created
        if currentUser.receiverKey == "" {
            currentUser.receiverKey = UUID().uuidString
        }

        let updatedUser = Profile(
            userId: currentUser.userId, email: currentUser.email, photoUrl: currentUser.photoUrl,
            firstName: currentUser.firstName, lastName: currentUser.lastName, myFont: currentUser.myFont,
            mySignature: k.appSignature, receiverKey: currentUser.receiverKey,totalMessagesSent: currentUser.totalMessagesSent, totalMessagesCreated: currentUser.totalMessagesCreated,  totalMyFavorites: currentUser.totalMyFavorites, totalReceiverFavorites: currentUser.totalReceiverFavorites)
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(
                userId: currentUser.userId)
//            updateSuccessful.toggle()
        }
        
        updateUserDefaults(person: currentUser)
//        updateSuccessful = true
//        print("\n Updated CurrentUserDefaults: \(currentUser)")
//        print("\n updateSuccessful: \(updateSuccessful)")
        print("\n Profile Updated")
    }

    
}

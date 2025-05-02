//
//  ProfileViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {

    private var k: Constants = Constants()
 //   @Published var thisUserId: String = ""
    @Published var currentUser: Person = Person(userId: "")
    
    @Published private(set) var user: Profile? = nil
    @Published var currentReceiver: Profile? = nil

    @Published var currentReceiverId: String = ""
    @Published var currentReceiverFirst: String = ""
    @Published var currentReceiverLast: String = ""
    @Published var currentReceiverEmail: String = ""

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
        
        print("vm: \(self.currentUser)" )
        if self.currentUser.firstName == "" {
            incompleteProfile = true
        }
    }

    func updateUserDefaults(person: Person) {
        
        if let encoded = try? JSONEncoder().encode(person) {
            UserDefaults.standard.set(encoded, forKey: k.user)
        }
    }
    
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
            mySignature: k.appSignature, receiverKey: currentUser.receiverKey)
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(
                userId: currentUser.userId)
            updateSuccessful.toggle()
        }
        
        updateUserDefaults(person: currentUser)
        print("Updated CurrentUserDefaults: \(currentUser)")
    }

//  ******************
//  Receiver Functions
    
    func getReceiver(email: String) async throws {
        do {
            currentReceiver = try await UserManager.shared.getUserWithEmail(
                email: email)

            currentReceiverId = self.currentReceiver?.userId ?? ""
            currentReceiverFirst = self.currentReceiver?.firstName ?? ""
            currentReceiverLast = self.currentReceiver?.lastName ?? ""
            currentReceiverEmail = self.currentReceiver?.email ?? ""
        } catch {
            print("no receiver with email: \(email) found")

        }
    }

    func createReceiver(
        userId: String, email: String, firstName: String, lastName: String,
        myFont: String, mySignature: String
    ) async throws {

        // check receiver is not already registered
        do {
            try await getReceiver(email: email)
        } catch  {
            print("creating new receiver: \(email)")
        }
       

        if UserManager.shared.newUser {
            let receiverUser = Profile(
                userId: userId, email: email, photoUrl: "no photo on file",
                dateCreated: Date(), firstName: firstName, lastName: lastName,
                myFont: myFont, mySignature: mySignature)

            Task {
                do {
                    try await UserManager.shared.updateUser(user: receiverUser)
                    updateSuccessful.toggle()
                } catch {
                    print("error creating receiver: \(error)")
                    throw error
                }
            }
        }
    }

}

//
//  ProfileViewModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {

    @Published private(set) var user: Profile? = nil
    @Published var currentReceiver: Profile? = nil

    @Published var currentUserEmail: String = ""
    @Published var currentUserFirstName: String = ""
    @Published var currentUserLastName: String = ""
    @Published var currentUserMyFont: String = ""
    @Published var currentUserDateCreated: Date = Date()
    @Published var currentUserPhotoUrl: String = ""
    @Published var currentUserMySignature: String = ""
    @Published var currentUserId: String = ""

    @Published var currentReceiverId: String = ""
    @Published var currentReceiverFirst: String = ""
    @Published var currentReceiverLast: String = ""
    @Published var currentReceiverEmail: String = ""

    @Published var updateSuccessful: Bool = false

    init() {
        //        do {
        //            Task {
        //                try await loadCurrentUser()
        //            }
        //        }
    }

    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(
            userId: authDataResult!.uid)
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

    func updateUser(
        email: String, firstName: String, lastName: String, myFont: String,
        mySignature: String
    ) {
        guard let user else { return }

        let updatedUser = Profile(
            userId: user.userId, email: email, photoUrl: user.photoUrl,
            firstName: firstName, lastName: lastName, myFont: myFont,
            mySignature: "")
        Task {
            try await UserManager.shared.updateUser(user: updatedUser)
            self.user = try await UserManager.shared.getUser(
                userId: user.userId)
            updateSuccessful.toggle()
        }
    }
}

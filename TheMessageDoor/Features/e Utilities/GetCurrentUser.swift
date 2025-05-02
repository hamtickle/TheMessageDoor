//
//  GetCurrentUser.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/22/25.
//

import Foundation

@MainActor
final class GetCurrentUser {
    
    static let shared = GetCurrentUser()
    private var k: Constants = Constants()
    @Published var currentUser: Person = Person(userId: "")
    
    @Published var appUser : Profile? = nil
    
        var thisUserId: String = ""
    
    @Published var user: Profile? = nil
    
    init() {
        Task {
            self.appUser =  try await loadCurrentUser()

            thisUserId = appUser?.userId ?? ""
            print("GetCurrentUser: \(thisUserId)")
            
            // Put UserData into User Defaults
            postToUserDefaults(appUser: appUser)
        }
        
    }
    
    func loadCurrentUser() async throws -> Profile? {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(
            userId: authDataResult!.uid)
        return user
    }

    
    func postToUserDefaults(appUser: Profile?) {
        var thisUser: Person = Person(userId: "")
        thisUser.userId = appUser?.userId ?? ""
        thisUser.firstName = appUser?.firstName ?? ""
        thisUser.lastName = appUser?.lastName ?? ""
        thisUser.email = appUser?.email ?? ""
        thisUser.photoUrl = appUser?.photoUrl ?? k.appProfileURL
        thisUser.myFont = appUser?.myFont ?? k.appFont
        thisUser.mySignature = appUser?.mySignature ?? k.appSignature
        thisUser.dateCreated = appUser?.dateCreated ?? k.oldDate
        thisUser.receiverKey = appUser?.receiverKey ?? ""
        thisUser.totalMessagesSent = appUser?.totalMessagesCreated ?? 0
        thisUser.totalMessagesCreated = appUser?.totalMessagesSent ?? 0
        thisUser.totalMyFavorites = appUser?.totalMessagesCreated ?? 0
        thisUser.totalReceiverFavorites = appUser?.totalMessagesCreated ?? 0
        
        
        if let encodedData = try? JSONEncoder().encode(thisUser) {
            UserDefaults.standard.set(encodedData, forKey: k.user)
        }
        print("user defaults: \(thisUser)")
    }
    
    func fetchUserDefaults() -> Person {
        guard
         let result = UserDefaults.standard.data(forKey: k.user),
         let currentUser = try? JSONDecoder().decode(Person.self, from: result)
        else { return Person(userId: "")}
        
        self.currentUser = currentUser
        return self.currentUser
    }
    
    
}

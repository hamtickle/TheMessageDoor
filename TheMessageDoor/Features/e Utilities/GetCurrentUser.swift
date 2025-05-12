//
//  GetCurrentUser.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/22/25.
//

import Foundation

@MainActor
final class GetCurrentUser: ObservableObject {
    
    private var k: Constants = Constants()
    @Published var currentUser: Person = Person(userId: "")
    @Published var currentUserStats: UserStats
    
    @Published var appUser : Profile? = nil
    @Published var user: Profile? = nil
    var thisUserId: String = ""
    var initialLoad: Bool
    
    init(initialLoad: Bool) {
        _currentUserStats = Published(wrappedValue: UserStats(userId: ""))
        self.initialLoad = initialLoad
        Task {
            if initialLoad {
                self.appUser =  try await loadCurrentUser()

                thisUserId = appUser?.userId ?? ""
                print("GetCurrentUser: \(thisUserId)")
                
                // Put UserData into User Defaults
                postToUserDefaults(appUser: appUser)
                
            } else {
                self.currentUser = fetchUserDefaults()
                self.initialLoad = false
            }
            
            
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
        
        if let encodedData = try? JSONEncoder().encode(thisUser) {
            UserDefaults.standard.set(encodedData, forKey: k.user)
        }
        print("user defaults: \(thisUser)")
        currentUser = thisUser
    }
    
    func fetchUserDefaults() -> Person {
        guard
         let result = UserDefaults.standard.data(forKey: k.user),
         let currentUser = try? JSONDecoder().decode(Person.self, from: result)
        else { return Person(userId: "")}
        
        self.currentUser = currentUser
        return self.currentUser
    }
    
    func getUserDefaults()  {
        _ = fetchUserDefaults()
    }
}

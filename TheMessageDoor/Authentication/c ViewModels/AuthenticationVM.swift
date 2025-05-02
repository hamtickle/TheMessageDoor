//
//  AuthVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class AuthenticationVM: ObservableObject {

    var thisUser: Person = Person(userId: "")
    let currentUser = GetCurrentUser()
    let signInAppleHelper = SignInAppleHelper()
    

    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.signInWithGoogle(tokens: tokens)
        
        let user = Profile(auth: authDataResult)
        
        // Bug fix - date created getting updated each log in.  Probably true of Apple login and email log in as well.
        // code is updating/replacing the entire profile each time I log in - so the dateCreated is getting replaced each login.
        // Need to find a way to save the createDate (UserDefaults?) and if there is a date in there, update the user.dateCreated before .createNewUser

        // check to see if User exists
        thisUser = currentUser.fetchUserDefaults()
        
        if thisUser.userId == user.userId {
            // user profile already exists, so don't update create a new user
            print("AuthVM: CurrentUserDefault \(thisUser.userId) vs LoggedInUserID: \(user.userId) \n" )
        } else {
            print(thisUser.userId, user.userId)
            // new user - create profile
            try await UserManager.shared.createNewUser(user: user)
            print("GetCurrentUser from AuthVM")
            GetCurrentUser()
        }

    }

    func signInApple() async throws {
        
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.signInWithApple(tokens: tokens)
        
        let user = Profile(auth: authDataResult)
        if let encodedData = try? JSONEncoder().encode(user.userId) {
            UserDefaults.standard.set(encodedData, forKey: "userId")}
        try await UserManager.shared.createNewUser(user: user)

    }
    
    // format for UserDefaults
    func createJSONString(user: Profile) -> String? {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var unwrappedDate = user.dateCreated ?? Date()
        var stringDate = df.string(from: unwrappedDate)
        return stringDate
    }
}

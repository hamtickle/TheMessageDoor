//
//  AuthVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class AuthenticationVM: ObservableObject {

    private var k: Constants = Constants()
    //    var thisUser: Person = Person(userId: "")

    let currentUser = GetCurrentUser(initialLoad: true)
    let signInAppleHelper = SignInAppleHelper()
    var thisUser = Profile(userId: "")
    
    init() {
        print("init AuthenticationVM \n")
    }

    func signInGoogle() async throws {

        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.signInWithGoogle(
            tokens: tokens)

        //new profile instance based on the login results from Google
        let user = Profile(auth: authDataResult)
        //        let initialLoad: Bool = true

        // retrieve UserProfile from Firebase User Collection (if it exists)
        do {
            let result = try await UserManager.shared.getUser(
                userId: user.userId)
            self.thisUser = result
        } catch {
            print("Error retrieving User from Firebase")
        }

        // check to see if they are the same user
        let newUser = compareUsers(user: user, thisUser: thisUser)

        if newUser {
            // if the User does not have a profile in Firebase, create one
            print("\n thisUser: \(thisUser.userId), User: \(user.userId)")

            // save to UserDefaults
            currentUser.postToUserDefaults(appUser: user)

            // new user - create profile in Firebase
            try await UserManager.shared.createNewUser(user: user)
            print("AuthVM - New User Created in Firebase \(user.userId)")

        } else {
            // user exists in Firebase, Set User Defaults
            do {
                let encodedData = try JSONEncoder().encode(thisUser)
                UserDefaults.standard.set(encodedData, forKey: k.user)
                print("\n UserDefaults for \(thisUser) updated")
            } catch {
                print("\n could not encode user \(thisUser)")
            }
//            if let encodedData = try? JSONEncoder().encode(thisUser) {
//                UserDefaults.standard.set(encodedData, forKey: k.user)
//            }

            currentUser.getUserDefaults()
            print(
                "\n CurrentUser: \(currentUser.currentUser.userId), \(currentUser.currentUser.firstName), \(currentUser.currentUser.lastName), \(currentUser.currentUser.email)"
            )
        }

        // Bug fix - date created getting updated each log in.  Probably true of Apple login and email log in as well.
        // code is updating/replacing the entire profile each time I log in - so the dateCreated is getting replaced each login.
        // Need to find a way to save the createDate (UserDefaults?) and if there is a date in there, update the user.dateCreated before .createNewUser

    }

    func compareUsers(user: Profile?, thisUser: Profile?) -> Bool {
        guard let user = user, let thisUser = thisUser else { return true }
        var newUser = true
        if user.userId == thisUser.userId,
            user.email == thisUser.email
        {
            newUser = false
        } else {
            newUser = true
        }

        return newUser
    }

    func signInApple() async throws {

        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.signInWithApple(
            tokens: tokens)

        let user = Profile(auth: authDataResult)
        if let encodedData = try? JSONEncoder().encode(user.userId) {
            UserDefaults.standard.set(encodedData, forKey: "userId")
        }
        try await UserManager.shared.createNewUser(user: user)

    }

    // format for UserDefaults
    func createJSONString(user: Profile) -> String? {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let unwrappedDate = user.dateCreated ?? Date()
        let stringDate = df.string(from: unwrappedDate)
        return stringDate
    }
}

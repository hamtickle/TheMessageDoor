//
//  AuthManager.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import FirebaseAuth
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?

    init(user: User) {  // User type is from Firebase - it is the returned type for Users.
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOptions: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthManager {

    static let shared = AuthManager()
    private init() {}

    func getAuthenticatedUser() throws -> AuthDataResultModel? {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)

        }
        return AuthDataResultModel(user: user)
    }

    func getProviders() throws -> [AuthProviderOptions] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.cancelled)
        }

        var providers: [AuthProviderOptions] = []
        for provider in providerData {
            if let option = AuthProviderOptions(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure(
                    "Unsupported provider: \(provider.providerID)")
            }
        }
        return providers
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.delete()
    }

}
//MARK:  email functions

extension AuthManager {

    @discardableResult
    func createUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().createUser(
            withEmail: email, password: password)
        // Store UserId in UserDefaults
        if let encodedData = try? JSONEncoder().encode(authDataResult.user.uid) {
            UserDefaults.standard.set(encodedData, forKey: "userId")
        }
        return AuthDataResultModel(user: authDataResult.user)

    }

    @discardableResult
    func signInUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().signIn(
            withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        try await user.updatePassword(to: password)
    }

    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        try await user.updateEmail(to: email)
    }
}

// MARK: SIGN IN SSO
extension AuthManager {

    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws
        -> AuthDataResultModel
    {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOptions.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        
        return try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws
        -> AuthDataResultModel
    {
        let credential = GoogleAuthProvider.credential(
            withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }

    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }

}

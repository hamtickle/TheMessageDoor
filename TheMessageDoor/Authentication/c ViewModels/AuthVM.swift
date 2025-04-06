//
//  AuthVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class AuthenticationVM: ObservableObject {

 
    let signInAppleHelper = SignInAppleHelper()

    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.signInWithGoogle(tokens: tokens)
        
        let user = Profile(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)

    }

    func signInApple() async throws {
        
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.signInWithApple(tokens: tokens)
        
        let user = Profile(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)

    }
}

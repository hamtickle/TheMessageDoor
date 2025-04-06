//
//  SignInWithEmailVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }

        let authDataResult = try await AuthManager.shared.createUser(
            email: email, password: password)
        let user = Profile(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)


    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }

        try await AuthManager.shared.signInUser(
            email: email, password: password)

    }
}

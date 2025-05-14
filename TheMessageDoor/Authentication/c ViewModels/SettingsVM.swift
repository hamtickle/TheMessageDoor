//
//  SettingsVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    private var k: Constants = Constants()
    @Published var authProviders: [AuthProviderOptions] = []

    func loadAuthProviders() {
        if let providers = try? AuthManager.shared.getProviders() {
            authProviders = providers
        }
    }

    func signOut() throws {
        try AuthManager.shared.signOut()
    }

    func deleteAccount() async throws {
        try await AuthManager.shared.deleteUser()
    }

    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()

        guard let email = authUser?.email else {
            throw URLError(.cancelled)
        }

        try await AuthManager.shared.resetPassword(email: email)
    }

    func updateEmail() async throws {
        let email = "hello123@example.com"
        try await AuthManager.shared.updateEmail(email: email)
    }

    func updatePassword() async throws {
        let password = "Nebraska"
        try await AuthManager.shared.updatePassword(password: password)
    }

    func getUserDefaults() {
        guard
            let result = UserDefaults.standard.data(forKey: k.user),
            let currentUser = try? JSONDecoder().decode(
                Person.self, from: result)

        else { return print("No User Defaults Found") }

        print("\n CurrentUserDefaults: \n \(currentUser) \n ")
    }

    func deleteUserDefaults() {
        UserDefaults.standard.removeObject(forKey: k.user)
        print("\n User Results Deleted")
    }
}

//
//  SettingsVM.swift
//  Auth
//
//  Created by Graham Tickell on 4/5/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

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
}

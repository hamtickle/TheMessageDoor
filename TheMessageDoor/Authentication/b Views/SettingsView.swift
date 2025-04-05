//
//  SettingsView.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        List {
            Button("Sign Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            }

            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            } label: {
                Text("Delete Account")
            }

            if viewModel.authProviders.contains(.email) {
                emailSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }

}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Requested password reset email")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }

            Button("Update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("SUCCESS: updated email")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }

            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("SUCCESS: updated password")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        } header: {
            Text("Email functions")
        }
    }
}

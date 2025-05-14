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

        Text("Settings")
            .font(.system(size: 34, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 10)

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

            Button() {
                viewModel.getUserDefaults()

            } label: {
                Text("Print UserDefaults")
            }
            
            Button(role: .destructive) {
                viewModel.deleteUserDefaults()

            } label: {
                Text("Delete UserDefaults")
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

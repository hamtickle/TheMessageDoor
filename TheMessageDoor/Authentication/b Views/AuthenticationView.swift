//
//  AuthenticationView.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct AuthenticationView: View {

    @StateObject private var viewModel = AuthenticationVM()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack(alignment: .center) {

            Text("Welcome to the Message Door")
                .font(.system(size: 36, weight: .bold, design: .default))
                .multilineTextAlignment(.center)

            Spacer()

            Image("Logo_TMD_large")
                .resizable()
                .frame(width: 100, height: 200)

            Spacer()

            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
            }


            GoogleSignInButton(
                viewModel: GoogleSignInButtonViewModel(
                    scheme: .dark, style: .standard, state: .normal)
            ) {
                Task {
                    do {
                        try await AuthenticationVM().signInGoogle()
                        showSignInView = false
                    } catch {
                        print("Error signing in: \(error)")
                    }
                }
            }


            Button(
                action: {
                    Task {
                        do {
                            try await AuthenticationVM().signInApple()
                                showSignInView = false
                        } catch {
                            print("Error signing in: \(error)")
                        }
                    }
                },
                label: {
                    SignInWithAppleButtonViewRepresentable(
                        type: .default, style: .whiteOutline
                    )
                    .allowsHitTesting(false)

                }
            )
            .frame(height: 55)


            Spacer()
        }
        .padding(70)
        //        .navigationTitle(Text("Welcome to the Message Door"))
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }

}



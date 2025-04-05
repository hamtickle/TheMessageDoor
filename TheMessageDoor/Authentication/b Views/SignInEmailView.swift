//
//  SignInEmailView.swift
//  Auth
//
//  Created by Graham Tickell on 3/31/25.
//

import SwiftUI

struct SignInEmailView: View {

    @StateObject private var vm = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .autocapitalization(.none)

                .cornerRadius(10)
            SecureField("Password...", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.4))

                .cornerRadius(10)

            Button {
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error signing up.  User already exists. ")
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                        print("Success signing in.")
                        return
                    } catch {
                        print("error signing in: \(error)")
                    }
                }

            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(Text("Sign In With Email"))
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }

}

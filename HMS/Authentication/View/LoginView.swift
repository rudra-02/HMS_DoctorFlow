//
//  LoginView.swift
//  HMS
//
//  Created by rjk on 21/04/25.
//


import SwiftUI

struct LoginScreen: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(colorScheme == .dark ? Theme.dark.tertiary : Theme.light.tertiary)

            VStack(alignment: .leading) {
                Text("Email")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your email",
                    isSecure: false,
                    text: $email,
                    errorMessage: emailError
                )
                .onChange(of: email) { _, newValue in
                    validateEmail(newValue)
                }
                .submitLabel(.next)
            }

            VStack(alignment: .leading) {
                Text("Password")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your password",
                    isSecure: true,
                    text: $password,
                    errorMessage: passwordError
                )
                .onChange(of: password) { _, newValue in
                    validatePassword(newValue)
                }
                .submitLabel(.go)
            }

            HStack {
                Spacer()
                Button(action: {
                    // Handle forgot password
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(colorScheme == .dark ? Theme.dark.tertiary : Theme.light.tertiary)
                        .font(.system(size: 14))
                }
            }

            Button(action: {
                // Handle login
            }) {
                Text("NEXT")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(isFormValid ? (colorScheme == .dark ? Theme.dark.primary : Theme.light.primary) : Color.blue.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)

            HStack {
                Text("Don't Have An Account?")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 14))
                Button(action: {
                    // Handle sign up
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 26)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(colorScheme == .dark ? Theme.dark.background : Theme.light.background) // Adapts to light/dark
    }

    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = "Email cannot be empty"
        } else if !email.contains("@") {
            emailError = "Email must contain '@'"
        } else {
            emailError = nil
        }
    }

    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = "Password cannot be empty"
        } else {
            let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
            let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
            let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
            let symbolSet = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?~`")
            let hasSymbol = password.rangeOfCharacter(from: symbolSet) != nil

            if !(hasUppercase && hasLowercase && hasNumber && hasSymbol) {
                passwordError = "Password must include uppercase, lowercase, number, and symbol"
            } else {
                passwordError = nil
            }
        }
    }
}

#Preview {
    LoginScreen()
}

//
//  SingUpView.swift
//  HMS
//
//  Created by rjk on 21/04/25.
//


import SwiftUI

struct SignUpScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var userName: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var userNameError: String? = nil
    @State private var nameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    
    private var isFormValid: Bool {
        return !userName.isEmpty &&
               !name.isEmpty &&
               !email.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty
    }
    
    var body: some View {
        let isDark = colorScheme == .dark
        
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isDark ? Theme.dark.tertiary : Theme.light.tertiary)
            
            VStack(alignment: .leading) {
                Text("User Name")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your user name",
                    isSecure: false,
                    text: $userName,
                    errorMessage: userNameError
                )
                .onChange(of: userName) { validateUserName(userName) }
            }
            
            VStack(alignment: .leading) {
                Text("Name")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your name",
                    isSecure: false,
                    text: $name,
                    errorMessage: nameError
                )
                .onChange(of: name) { validateName(name) }
            }
            
            VStack(alignment: .leading) {
                Text("Email")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your email",
                    isSecure: false,
                    text: $email,
                    errorMessage: emailError
                )
                .onChange(of: email) { validateEmail(email) }
            }
            
            VStack(alignment: .leading) {
                Text("Password")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Enter your password",
                    isSecure: true,
                    text: $password,
                    errorMessage: passwordError
                )
                .onChange(of: password) { validatePassword(password) }
            }
            
            VStack(alignment: .leading) {
                Text("Confirm Password")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                CustomTextField(
                    placeholder: "Confirm your password",
                    isSecure: true,
                    text: $confirmPassword,
                    errorMessage: confirmPasswordError
                )
                .onChange(of: confirmPassword) { validateConfirmPassword(confirmPassword) }
            }
            
            Button(action: {
                // Handle sign up action
            }) {
                Text("NEXT")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(isFormValid ? (isDark ? Theme.dark.primary : Theme.light.primary) : Color.blue.opacity(0.3))
                    .cornerRadius(12)
            }
            .padding(.top, 30)
            .disabled(!isFormValid)
            
            HStack {
                Text("Already Have An Account?")
                    .foregroundColor(isDark ? .white : .black)
                    .font(.system(size: 14))
                Button(action: {
                    // Navigate to login
                }) {
                    Text("Login")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                }
            }
        }
        .padding([.leading, .trailing], 26)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(isDark ? Color.black : Color(UIColor.systemGray6))
    }
    
    // MARK: - Validation Methods
    private func validateUserName(_ userName: String) {
        userNameError = userName.isEmpty ? "Username cannot be empty" : nil
    }

    private func validateName(_ name: String) {
        nameError = name.isEmpty ? "Name cannot be empty" : nil
    }

    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = "Email cannot be empty"
        } else if !email.contains("@") {
            emailError = "Invalid email format"
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

    private func validateConfirmPassword(_ confirmPassword: String) {
        confirmPasswordError = confirmPassword != password ? "Passwords do not match" : nil
    }
}

#Preview {
    SignUpScreen()
}

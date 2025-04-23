//
//  CustomTextField.swift
//  HMS
//
//  Created by rjk on 21/04/25.
//


import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var text: String
    var errorMessage: String? // Optional error message
    
    @State private var isTextHidden: Bool = true // State variable that toggles visibility of the text (for secure fields)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) { // Use VStack to stack text field and error message
            ZStack {
                Color.white
                    .cornerRadius(6)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                HStack {
                    
                    // Conditional text field or secure text field
                    if isSecure {
                        Group {
                            if isTextHidden {
                                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray).font(.system(size: 12)))
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray).font(.system(size: 12)))
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.password)
                            }
                        }
                        .padding(.horizontal, 10)
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray).font(.system(size: 12)))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 10)
                    }
                    
                    // Toggle button for showing/hiding password text
                    if isSecure {
                        Button(action: {
                            isTextHidden.toggle()
                        }) {
                            Image(systemName: isTextHidden ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                    }
                }
                .frame(height: 40)
                .font(.system(size: 16))
            }
            
            // Optional error message
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
        .frame(height: errorMessage != nil ? 60 : 40) // Adjust height based on error presence
    }
}

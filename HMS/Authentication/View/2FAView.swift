//
//  2FAView.swift
//  HMS
//
//  Created by rjk on 22/04/25.
//

import SwiftUI

struct TwoFAView: View {
    @State private var otpFields: [String] = ["", "", "", ""]
    @FocusState private var focusedIndex: Int?
    
    @State private var secondsRemaining = 30
    @State private var timerRunning = true

    var body: some View {
        VStack() {
            Spacer()
            
            Text("OTP Verification")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.light.tertiary)
                .padding(.bottom,8)
            
            Text("Please check your email address and write the OTP code you received here.")
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
                .padding(.horizontal)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $otpFields[index])
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .font(.title)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: otpFields[index]) { newValue in
                            if newValue.count > 1 {
                                otpFields[index] = String(newValue.prefix(1))
                            }
                            if !newValue.isEmpty {
                                triggerHaptic()
                                if index < 3 {
                                    focusedIndex = index + 1
                                } else {
                                    focusedIndex = nil
                                }
                            }
                        }
                }
            }
            .padding(.top, 20)
            
            Text("Didn’t receive mail?")
                .padding(.top, 35)
                .padding(.bottom, 2)
            
            if timerRunning {
                HStack {
                    Text("You can resend code in")
                        .foregroundColor(.black)
                        .padding(.zero)
                    Text("\(secondsRemaining)")
                        .foregroundColor(Theme.light.primary)
                        .padding(.zero)
                    Text("s")
                        .foregroundColor(.black)
                        .padding(.zero)
                }
            } else {
                Button(action: {
                    startTimer()
                }) {
                    Text("Resend")
                        .foregroundColor(.blue)
                        .bold()
                }
            }
            
            Spacer()
            
            Button(action: {
                // Handle OTP submission
            }) {
                Text("NEXT")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isOTPComplete ? Color.blue : Color.blue.opacity(0.4))
                    .cornerRadius(12)
            }
            .disabled(!isOTPComplete)
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            startTimer()
            focusedIndex = 0
        }
    }
    
    var isOTPComplete: Bool {
        otpFields.allSatisfy { $0.count == 1 }
    }

    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func startTimer() {
        secondsRemaining = 30
        timerRunning = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer.invalidate()
                timerRunning = false
            }
        }
    }
}

#Preview {
    TwoFAView()
}

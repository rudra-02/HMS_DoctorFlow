//
//  DoctorProfileView.swift
//  HMS
//
//  Created by Rudra Pruthi on 24/04/25.
//
import SwiftUI

struct DoctorProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image("person1")
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .padding(.top, 40)

            Text("Dr. Kanav Nijhawan")
                .font(.title)
                .bold()
                .foregroundColor(theme.text)

            Text("Age: 35")
                .foregroundColor(.gray)

            Text("Speciality: Cardiology")
                .foregroundColor(.gray)

            Spacer()

            Button(action: {
                print("Logging out…")
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()

        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.background.ignoresSafeArea())
    }
}

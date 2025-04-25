//
//  ConsultationCard.swift
//  HMS
//
//  Created by Rudra Pruthi on 23/04/25.
//


import SwiftUI

struct ConsultationCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let patientName: String
    @State private var prescription: String = ""
    @State private var notes: String = ""
    @State private var selectedTab: String = "CONSULT"
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {

            // Header
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(patientName)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(theme.text)

                    Text("Dr. Kanav Nijhawan")
                        .font(.title3)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image("profile_placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }
            .padding(.horizontal)

            // Toggle Tabs
            HStack(spacing: 0) {
                SegmentButton(title: "Consult", isSelected: selectedTab == "CONSULT", theme: theme) {
                    selectedTab = "CONSULT"
                }
                SegmentButton(title: "Patient History", isSelected: selectedTab == "PATIENT HISTORY", theme: theme) {
                    selectedTab = "PATIENT HISTORY"
                    prescription = ""
                    notes = ""
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)

            if selectedTab == "CONSULT" {
                // Prescription
                VStack(alignment: .leading, spacing: 8) {
                    Text("PRESCRIPTION:")
                        .font(.headline)
                        .foregroundColor(theme.text)

                    TextEditor(text: $prescription)
                        .frame(height: 150)
                        .padding(10)
                        .background(colorScheme == .dark ? Color(hex: "#333333") : Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Notes
                VStack(alignment: .leading, spacing: 8) {
                    Text("NOTES:")
                        .font(.headline)
                        .foregroundColor(theme.text)

                    TextEditor(text: $notes)
                        .frame(height: 120)
                        .padding(10)
                        .background(colorScheme == .dark ? Color(hex: "#333333") : Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            } else {
                // Patient History Placeholder
                VStack {
                    Spacer()
                    Text("No patient history data to show.")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            }

            Spacer()

            // Buttons
            HStack(spacing: 16) {
                Button(action: {
                    print("💾 Draft Saved")
                }) {
                    HStack {
                        Image(systemName: "tray.and.arrow.down.fill")
                        Text("Save Draft")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(theme.primary, lineWidth: 1.5)
                    )
                    .foregroundColor(theme.primary)
                    .shadow(color: theme.shadow, radius: 4, x: 0, y: 2)
                }

                Button(action: {
                    print("✅ Consultation Done")
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.primary)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: theme.shadow, radius: 6, x: 0, y: 3)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 36) // Extra bottom space
        }
        .padding(.top)
        .background(theme.background)
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Segment Button
struct SegmentButton: View {
    var title: String
    var isSelected: Bool
    var theme: Theme
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? theme.primary : theme.card)
                .foregroundColor(isSelected ? .white : theme.primary)
                .font(.headline)
        }
        .background(isSelected ? theme.primary : theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview{
    ConsultationCard(patientName: "Vishal")
}

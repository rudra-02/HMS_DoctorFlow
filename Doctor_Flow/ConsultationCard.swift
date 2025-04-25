//
//  ConsultationCard.swift
//  HMS
//
//  Created by Rudra Pruthi on 23/04/25.
//


import SwiftUI

struct ConsultationCard: View {
    let patientName: String
    @State private var prescription: String = ""
    @State private var notes: String = ""
    @State private var selectedTab: String = "CONSULT"

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {

            // Header
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(patientName)")
                        .font(.largeTitle)
                        .bold()

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
                SegmentButton(title: "Consult", isSelected: selectedTab == "CONSULT") {
                    selectedTab = "CONSULT"
                }
                SegmentButton(title: "Patient History", isSelected: selectedTab == "PATIENT HISTORY") {
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

                    TextEditor(text: $prescription)
                        .frame(height: 150)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Notes
                VStack(alignment: .leading, spacing: 8) {
                    Text("NOTES:")
                        .font(.headline)

                    TextEditor(text: $notes)
                        .frame(height: 120)
                        .padding(10)
                        .background(Color(.systemGray6))
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
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.light.primary, lineWidth: 1.5)
                    )
                    .foregroundColor(Theme.light.primary)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
                    .background(Theme.light.primary)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 36) // Extra bottom space
        }
        .padding(.top)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Segment Button
struct SegmentButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Theme.light.primary : Color.white)
                .foregroundColor(isSelected ? .white : Theme.light.primary)
                .font(.headline)
        }
        .background(isSelected ? Theme.light.primary : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview{
    ConsultationCard(patientName: "Vishal")
}

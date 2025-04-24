//
//  DashboardView.swift
//  HMS
//
//  Created by Rudra Pruthi on 23/04/25.
//
import SwiftUI

struct DashboardView: View {
    @State private var selectedTab: String = "Upcoming"
    @State private var selectedIndex: Int = 0 // 0 - Dashboard, 1 - Slots, 2 - Patients
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if selectedIndex == 0 {
                    DashboardContent(selectedTab: $selectedTab)
                } else if selectedIndex == 1 {
                    ManageSlotsView() // Placeholder view
                } else if selectedIndex == 2 {
                    PatientsView() // Placeholder view
                }

                Divider()
            }
            .background(Theme.light.background)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Dashboard Main Content
struct DashboardContent: View {
    @Binding var selectedTab: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Good Morning")
                        .font(.title)
                        .bold()
                    Text("Dr. Kanav Nijhawan")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image("person1")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
            }
            .padding(.horizontal)

            HStack {
                Button(action: {
                    selectedTab = "Upcoming"
                }) {
                    Text("Upcoming")
                        .foregroundColor(selectedTab == "Upcoming" ? .white : .blue)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Upcoming" ? Color.blue : Color.clear)
                        .cornerRadius(25)
                }
                Button(action: {
                    selectedTab = "Past"
                   
                }) {
                    Text("Past")
                        .foregroundColor(selectedTab == "Past" ? .white : .blue)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Past" ? Color.blue : Color.clear)
                        .cornerRadius(25)
                }
            }
            .background(Color.white)
            .clipShape(Capsule())
            .frame(height: 45)
            .padding(.horizontal)

            // 👇 See All Button only for "Past"
            if selectedTab == "Past" {
                HStack {
                    Spacer()
                    Button(action: {
                        print("See all past appointments tapped")
                    }) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
            }

            ScrollView {
                VStack(spacing: 16) {
                    let listToShow = selectedTab == "Upcoming" ? appointments : pastAppointments
                    ForEach(listToShow) { appointment in
                        AppointmentCard(appointment: appointment, isPast: selectedTab == "Past")
                    }
                }
                .padding()
            }

            Spacer()
        }
    }
}



// MARK: - Reusable Tab Item
struct TabItem: View {
    let image: String
    let title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        VStack {
            Image(systemName: image)
                .foregroundColor(isSelected ? .blue : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .onTapGesture {
            action()
        }
    }
}


struct AppointmentCard: View {
    let appointment: Appointment
    var isPast: Bool = false  // Default to upcoming

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(appointment.imageName)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(appointment.patientName)
                        .bold()
                    Text(appointment.issue)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
                Text(appointment.time)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 8)

            if isPast {
                // ✅ Show only this for past appointments
                Button(action: {
                    print("📋 Show History tapped for \(appointment.patientName)")
                }) {
                    Text("Show History")
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .padding()
                        .background(Color(hex: "#61AAF2"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            } else {
                // ✅ Upcoming actions
                HStack {
                    NavigationLink(destination: ConsultationCard(patientName: "\(appointment.patientName)")) {
                        Text("Start Consult")
                            .frame(maxWidth: .infinity, maxHeight: 2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }

                    Button(action: {
                        print("Reschedule \(appointment.patientName)")
                    }) {
                        Text("Reschedule")
                            .frame(maxWidth: .infinity, maxHeight: 2)
                            .padding()
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }


    // MARK: - Temporary actions
    func startConsult(for appointment: Appointment) {
        print("Starting consultation with \(appointment.patientName)")
    }

    func rescheduleAppointment(for appointment: Appointment) {
        print("Rescheduling appointment with \(appointment.patientName)")
    }
}



#Preview{
    DoctorTabView()
}

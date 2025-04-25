//
//  DashboardView.swift
//  HMS
//
//  Created by Rudra Pruthi on 23/04/25.
//
import SwiftUI
//
//struct DashboardView: View {
//    @State private var selectedTab: String = "Upcoming"
//    @State private var selectedIndex: Int = 0 // 0 - Dashboard, 1 - Slots, 2 - Patients
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                if selectedIndex == 0 {
//                    DashboardContent(selectedTab: $selectedTab)
//                } else if selectedIndex == 1 {
//                    DoctorSlotManagerView() // Placeholder view
//                } else if selectedIndex == 2 {
//                    PatientsView() // Placeholder view
//                }
//
//                Divider()
//            }
//            .background(Theme.dark.background)
//            .navigationBarHidden(true)
//        }
//    }
//}

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
                NavigationLink(destination: DoctorProfileView()) {
                    Image("person1")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal)

            HStack {
                Button(action: {
                    selectedTab = "Upcoming"
                }) {
                    Text("Upcoming")
                        .foregroundColor(selectedTab == "Upcoming" ? .white : Theme.light.primary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Upcoming" ? Theme.light.primary : Color.clear)
                        .cornerRadius(25)
                }
                Button(action: {
                    selectedTab = "Past"
                   
                }) {
                    Text("Past")
                        .foregroundColor(selectedTab == "Past" ? .white : Theme.light.primary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Past" ? Theme.light.primary : Color.clear)
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
                    NavigationLink(destination: PastAppointmentsCalendarView()) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(Theme.light.primary)
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
                .foregroundColor(isSelected ? Theme.light.primary : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? Theme.light.primary : .gray)
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
                    .foregroundColor(Theme.light.primary)
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
                            .background(Theme.light.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }

                    NavigationLink(destination: RescheduleView(appointment: appointment, initialDate: appointment.date)){
                        Text("Reschedule")
                            .frame(maxWidth: .infinity, maxHeight: 2)
                            .padding()
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Theme.light.primary, lineWidth: 1)
                            )
                            .foregroundColor(Theme.light.primary)
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

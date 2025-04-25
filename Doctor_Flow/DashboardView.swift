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
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTab: String
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Good Morning")
                        .font(.title)
                        .bold()
                        .foregroundColor(theme.text)
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
                        .foregroundColor(selectedTab == "Upcoming" ? .white : theme.primary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Upcoming" ? theme.primary : Color.clear)
                        .cornerRadius(25)
                }
                Button(action: {
                    selectedTab = "Past"
                   
                }) {
                    Text("Past")
                        .foregroundColor(selectedTab == "Past" ? .white : theme.primary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(selectedTab == "Past" ? theme.primary : Color.clear)
                        .cornerRadius(25)
                }
            }
            .background(theme.card)
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
                            .foregroundColor(theme.primary)
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
    @Environment(\.colorScheme) private var colorScheme
    let image: String
    let title: String
    var isSelected: Bool
    var action: () -> Void
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }

    var body: some View {
        VStack {
            Image(systemName: image)
                .foregroundColor(isSelected ? theme.primary : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? theme.primary : .gray)
        }
        .onTapGesture {
            action()
        }
    }
}


struct AppointmentCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let appointment: Appointment
    var isPast: Bool = false  // Default to upcoming
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }

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
                        .foregroundColor(theme.text)
                    Text(appointment.issue)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
                Text(appointment.time)
                    .foregroundColor(theme.primary)
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
                        .background(theme.tertiary)
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
                            .background(theme.primary)
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
                                    .stroke(theme.primary, lineWidth: 1)
                            )
                            .foregroundColor(theme.primary)
                    }
                }
            }
        }
        .padding()
        .background(theme.card)
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

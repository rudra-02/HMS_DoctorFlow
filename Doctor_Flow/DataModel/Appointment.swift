import Foundation

struct Appointment: Identifiable {
    let id = UUID()
    let patientName: String
    let time: String
    let issue: String
    let duration: Int
    let imageName: String
    let date: Date  // ✅ New property
}

// MARK: - Helper date formatter for sample dates

private let formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd MMM yyyy HH:mm"
    return f
}()

// MARK: - Upcoming Appointments
let appointments: [Appointment] = [
    Appointment(
        patientName: "Vishal Ara",
        time: "Today, 15:30",
        issue: "High Fever",
        duration: 30,
        imageName: "person1",
        date: Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!
    ),
    Appointment(
        patientName: "Kanav Nijhawan",
        time: "Today, 16:00",
        issue: "Severe Headache",
        duration: 30,
        imageName: "person2",
        date: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
    ),
    Appointment(
        patientName: "Prasanjit Panda",
        time: "Tomorrow, 16:30",
        issue: "Hip replacement surgery",
        duration: 60,
        imageName: "person3",
        date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    )
]


// MARK: - Past Appointments
let pastAppointments: [Appointment] = [
    Appointment(
        patientName: "Sanya Mehta",
        time: "10 Apr, 3:00 PM",
        issue: "Follow-up",
        duration: 20,
        imageName: "person2",
        date: formatter.date(from: "10 Apr 2025 15:00")!
    ),
    Appointment(
        patientName: "Aditya Kapoor",
        time: "8 Apr, 11:30 AM",
        issue: "Post Surgery",
        duration: 45,
        imageName: "person3",
        date: formatter.date(from: "08 Apr 2025 11:30")!
    )
]

//
//  Appointment.swift
//  HMS
//
//  Created by Rudra Pruthi on 22/04/25.
//


import Foundation

struct Appointment: Identifiable {
    let id = UUID()
    let patientName: String
    let time: String
    let issue: String
    let duration: Int = 0
    let imageName: String
}

let appointments: [Appointment] = [
    Appointment(patientName: "Vishal Ara", time: "Today, 15:30", issue: "High Fever", imageName: "person1"),
    Appointment(patientName: "Kanav Nijhawan", time: "Today, 16:00", issue: "Severe Headache", imageName: "person2"),
    Appointment(patientName: "Prasanjit Panda", time: "Tomorrow, 16:30", issue: "Hip replacement surgery", imageName: "person3")
]

let pastAppointments: [Appointment] = [
    Appointment(patientName: "Sanya Mehta",  time: "10 Apr, 3:00 PM", issue: "Follow-up", imageName: "person2"),
    Appointment(patientName: "Aditya Kapoor", time: "8 Apr, 11:30 AM", issue: "Post Surgery", imageName: "person3")
    // Add more if you like
]


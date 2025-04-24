//
//  DoctorTabView.swift
//  HMS
//
//  Created by Rudra Pruthi on 23/04/25.
//
import SwiftUI

struct DoctorTabView: View {
    @State private var selectedIndex: Int = 0
    @State private var selectedTab: String = "Upcoming" // for Dashboard's capsule tabs
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                // Switch between doctor screens
                Group {
                    switch selectedIndex {
                    case 0:
                        DashboardContent(selectedTab: $selectedTab)
                    case 1:
                        DoctorSlotManagerView()
                    case 2:
                        PatientsView()
                    default:
                        DashboardContent(selectedTab: $selectedTab)
                    }
                }
                
                Divider()
                
                // Reusable tab bar
                DoctorTabBar(selectedIndex: $selectedIndex)
            }
            .background(Theme.light.background)
            .navigationBarHidden(true)
        }
    }
}

struct DoctorTabBar: View {
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            TabItem(image: "house", title: "Dashboard", isSelected: selectedIndex == 0) {
                selectedIndex = 0
            }.font(.system(size: 25))
            Spacer()
            TabItem(image: "calendar", title: "Manage Slots", isSelected: selectedIndex == 1) {
                selectedIndex = 1
            }.font(.system(size: 25))
            Spacer()
            TabItem(image: "person.2", title: "Patients", isSelected: selectedIndex == 2) {
                selectedIndex = 2
            }.font(.system(size: 25))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .frame(height: 40)
    }
}


// MARK: - Placeholder Views
struct ManageSlotsView: View {
    var body: some View {
        VStack {
            Text("Manage Slots Screen")
                .font(.title2)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

struct PatientsView: View {
    var body: some View {
        VStack {
            Text("Patients Screen")
                .font(.title2)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

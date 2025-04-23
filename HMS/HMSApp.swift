//
//  HMSApp.swift
//  HMS
//
//  Created by admin49 on 21/04/25.
//

import SwiftUI

@main
struct HMSApp: App {
    var body: some Scene {
        WindowGroup {
//            SignUpScreen()
            DoctorTabView()
        }
    }
}

//struct DoctorFlow: View {
//    var body: some View {
//        TabView {
//            DashboardView()
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Dashboard")
//                }
//            
//            DashboardView()
//                .tabItem {
//                    Image(systemName: "calendar")
//                    Text("Manage Slots")
//                }
//            
//            DashboardView()
//                .tabItem {
//                    Image(systemName: "person.2")
//                    Text("Patients")
//                }
//        }.padding()
//        .background(Color.white)
//        .frame(height: 40)
//    }
//}


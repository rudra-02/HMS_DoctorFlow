//
//  PastAppointmentsCalendarView.swift
//  HMS
//
//  Created by Rudra Pruthi on 25/04/25.
//
import SwiftUI

struct PastAppointmentsCalendarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedDate: Date = Date()
    @State private var currentMonthOffset: Int = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    private let calendar = Calendar.current
    private let today = Calendar.current.startOfDay(for: Date())
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }

    // All appointments grouped by date
    private var groupedAppointments: [Date: [Appointment]] {
        Dictionary(grouping: pastAppointments, by: {
            calendar.startOfDay(for: $0.date)
        })
    }
    
    private var displayedMonth: Date {
        calendar.date(byAdding: .month, value: currentMonthOffset, to: today)!
    }
    
    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else {
            return []
        }
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Month Selector
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(theme.primary)
                }
                Spacer()
                Text(monthYearString(from: displayedMonth))
                    .font(.headline)
                    .foregroundColor(theme.text)
                Spacer()
                Button(action: {
                    currentMonthOffset += 1
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(theme.primary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)

            // MARK: - Date Strip
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(daysInMonth, id: \.self) { date in
                            let isFuture = date > today
                            let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                            let isToday = calendar.isDateInToday(date)
                            let hasAppointment = groupedAppointments.keys.contains(calendar.startOfDay(for: date))

                            VStack(spacing: 4) {
                                Text(shortDayOfWeek(from: date))
                                    .font(.caption2)
                                    .foregroundColor(
                                        isFuture ? .gray.opacity(0.4) :
                                        isSelected ? .white :
                                        .gray
                                    )

                                Text(dayNumber(from: date))
                                    .fontWeight(.medium)
                                    .foregroundColor(
                                        isFuture ? .gray.opacity(0.4) :
                                        isSelected ? .white :
                                        isToday ? theme.primary :
                                        theme.text
                                    )

                                // Dot badge (for appointments)
                                if hasAppointment {
                                    Circle()
                                        .fill(isSelected ? Color.white : theme.primary)
                                        .frame(width: 6, height: 6)
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(10)
                            .background(isSelected ? theme.primary : Color.clear)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(isToday && !isSelected ? theme.primary : Color.clear, lineWidth: 1)
                            )
                            .onTapGesture {
                                if !isFuture {
                                    selectedDate = date
                                }
                            }
                            .opacity(isFuture ? 0.5 : 1)
                            .id(date)
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    scrollProxy = proxy
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if daysInMonth.contains(today) {
                            proxy.scrollTo(today, anchor: .center)
                            selectedDate = today
                        }
                    }
                }
            }
            .padding(.bottom, 6)

            Divider()

            // MARK: - Header
            Text("Appointments on \(formattedFullDate(selectedDate))")
                .font(.headline)
                .foregroundColor(theme.text)
                .padding(.horizontal)

            // MARK: - Appointment List
            ScrollView {
                let filteredAppointments = pastAppointments.filter {
                    calendar.isDate($0.date, inSameDayAs: selectedDate)
                }

                if filteredAppointments.isEmpty {
                    Text("No appointments found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredAppointments) { appointment in
                        AppointmentCard(appointment: appointment, isPast: true)
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("Past Appointments")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.background)
    }

    // MARK: - Helpers
    private func shortDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    PastAppointmentsCalendarView()
}

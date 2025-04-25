import SwiftUI

struct TimeSlot {
    let time: String
    let isAvailable: Bool
}

struct RescheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    let appointment: Appointment
    @State private var selectedDate: Date
    @State private var selectedNewTimeSlot: TimeSlot? = nil
    
    let morningTimeSlots = ["9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM"]
    let afternoonTimeSlots = ["3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM"]
    
    init(appointment: Appointment, initialDate: Date) {
        self.appointment = appointment
        self._selectedDate = State(initialValue: initialDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Current appointment info
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Appointment").font(.subheadline).foregroundColor(.secondary)
                HStack {
                    VStack(alignment: .leading) {
                        Text(appointment.patientName).font(.headline)
                        Text("\(appointment.time)").font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            
            // Date selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Select New Date").font(.headline).foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)
            }
            
            calendarStrip
            
            Divider()
            
            // Time slots
            VStack(alignment: .leading, spacing: 8) {
                Text("Select New Time").font(.headline).foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)
            }
            
            timeSlotSelectionView
        }
        .navigationTitle("Reschedule Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveReschedule()
                }
                .disabled(selectedNewTimeSlot == nil)
                .fontWeight(.semibold)
            }
        }
    }
    
    var calendarStrip: some View {
        let dates = getNext30Days()
        return VStack(spacing: 0) {
            HStack {
                Text(monthYearString(from: selectedDate)).font(.headline).padding(.leading)
                Spacer()
            }.padding(.vertical, 8)
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(dates, id: \.self) { date in
                            let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            let isToday = Calendar.current.isDateInToday(date)
                            let hasAppointments = !appointmentsForDate(date).isEmpty
                            Button {
                                withAnimation {
                                    selectedDate = date
                                    selectedNewTimeSlot = nil
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Text(dayOfWeek(from: date)).font(.caption).fontWeight(.medium)
                                        .foregroundColor(isSelected ? .white : .secondary)
                                    Text("\(Calendar.current.component(.day, from: date))").font(.headline).fontWeight(.bold)
                                        .foregroundColor(isSelected ? .white : isToday ? .blue : .primary)
                                    Circle().fill(hasAppointments ? (isSelected ? Color.white : Color.blue) : Color.clear)
                                        .frame(width: 4, height: 4)
                                }
                                .frame(width: 60, height: 70)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isSelected ? Color.blue : isToday ? Color.blue.opacity(0.1) : Color.clear)
                                )
                            }
                            .id(date)
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    scrollProxy.scrollTo(selectedDate, anchor: .center)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    var timeSlotSelectionView: some View {
        let availableSlots = availableTimeSlotsForDate(selectedDate)
        
        return ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Morning
                VStack(alignment: .leading, spacing: 12) {
                    Text("Morning (9:00 AM - 12:30 PM)").font(.headline).foregroundColor(.secondary).padding(.horizontal)
                    let morningSlots = availableSlots.filter { morningTimeSlots.contains($0.time) }
                    if morningSlots.isEmpty {
                        Text("No available morning slots").font(.subheadline).foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center).padding()
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(morningSlots, id: \.time) { slot in
                                TimeSlotButton(timeSlot: slot, isSelected: selectedNewTimeSlot?.time == slot.time) {
                                    if slot.isAvailable { selectedNewTimeSlot = slot }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Afternoon
                VStack(alignment: .leading, spacing: 12) {
                    Text("Afternoon (3:00 PM - 5:30 PM)").font(.headline).foregroundColor(.secondary).padding(.horizontal)
                    let afternoonSlots = availableSlots.filter { afternoonTimeSlots.contains($0.time) }
                    if afternoonSlots.isEmpty {
                        Text("No available afternoon slots").font(.subheadline).foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center).padding()
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(afternoonSlots, id: \.time) { slot in
                                TimeSlotButton(timeSlot: slot, isSelected: selectedNewTimeSlot?.time == slot.time) {
                                    if slot.isAvailable { selectedNewTimeSlot = slot }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Helper Functions
    func saveReschedule() {
        if let newTime = selectedNewTimeSlot {
            print("Rescheduled \(appointment.patientName) from \(appointment.time) to \(formattedDateShort(selectedDate)) at \(newTime.time)")
            // Here you would add code to actually update the appointment in your data model
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func appointmentsForDate(_ date: Date) -> [Appointment] {
        let calendar = Calendar.current
        return (appointments + pastAppointments)
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date < $1.date }
    }
    
    func availableTimeSlotsForDate(_ date: Date) -> [TimeSlot] {
        let existingAppointments = appointmentsForDate(date)
        var slots: [TimeSlot] = []
        
        for timeString in morningTimeSlots + afternoonTimeSlots {
            let isBooked = existingAppointments.contains {
                parseTime($0.time) == timeString && $0.id != appointment.id
            }
            slots.append(TimeSlot(time: timeString, isAvailable: !isBooked))
        }
        return slots
    }
    
    func parseTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ", ")
        guard components.count == 2 else { return timeString }
        let timePart = components[1]
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if let date = timeFormatter.date(from: String(timePart)) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"
            return outputFormatter.string(from: date)
        }
        return String(timePart)
    }
    
    func getNext30Days() -> [Date] {
        let calendar = Calendar.current
        let startDate = Date()
        return (0..<30).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
    }
    
    func dayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func formattedDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct TimeSlotButton: View {
    let timeSlot: TimeSlot
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(timeSlot.time)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(timeSlot.isAvailable ? (isSelected ? .white : .primary) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
        }
        .disabled(!timeSlot.isAvailable)
    }
    
    private var backgroundColor: Color {
        if !timeSlot.isAvailable { return Color.gray.opacity(0.1) }
        else if isSelected { return Color.blue }
        else { return Color.white }
    }
    
    private var borderColor: Color {
        if !timeSlot.isAvailable { return Color.gray.opacity(0.2) }
        else if isSelected { return Color.blue }
        else { return Color.gray.opacity(0.3) }
    }
}

#Preview {
    RescheduleView(appointment: appointments[0], initialDate: appointments[0].date)
}

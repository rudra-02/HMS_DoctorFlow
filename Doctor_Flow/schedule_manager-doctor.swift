

import SwiftUI


struct DoctorSlotManagerView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedDate: Date = Date()
    @State private var fullDayLeaves: Set<Date> = []
    @State private var leaveTimeSlots: [Date: Set<String>] = [:]
    @State private var showUndoAlert: Bool = false
    @State private var lastAction: (date: Date, slots: Set<String>)? = nil
    @State private var actionType: ActionType = .none
    @State private var showSuccessToast: Bool = false
    @State private var showDatePicker: Bool = false
    
    private var theme: Theme {
        colorScheme == .dark ? Theme.dark : Theme.light
    }
    
    // Define the specific color for leaves - #61aaf2
    let leaveColor = Color(hex: "#61aaf2")
    // Define red color specifically for leave markings
    let redLeaveColor = Color(hex: "#FF0000")
    
    enum ActionType {
        case none, blockSlot, blockFullDay
    }
    
    let timeSlots = [
        "09:00 AM", "09:30 AM", "10:00 AM",
        "10:30 AM", "11:00 AM", "11:30 AM",
        "03:00 PM", "03:30 PM", "04:00 PM",
        "04:30 PM", "05:00 PM", "05:30 PM"
    ]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Spacer()
                    Text("MANAGE SLOTS")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.text)
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Date selector with legend
                        VStack(alignment: .leading, spacing: 14) {
                            
                            // Date Picker Button
                            Button(action: {
                                showDatePicker = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Selected Date")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text(formattedDate(selectedDate))
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(theme.text)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundColor(theme.primary)
                                }
                                .padding()
                                .background(theme.card)
                                .cornerRadius(12)
                                .shadow(color: theme.shadow, radius: 2)
                            }
                            
                            // Legend
                            HStack(spacing: 20) {
                                LegendItem(color: theme.primary, text: "Selected")
                                LegendItem(color: redLeaveColor, text: "Leave")
                                LegendItem(color: .green, text: "Today")
                            }
                            .padding(.vertical, 6)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Action buttons for selected date
                        HStack {
                            let isFullDayBlocked = fullDayLeaves.contains(selectedDate)
                            
                            // Block/Unblock Full Day
                            ActionButton(
                                icon: isFullDayBlocked ? "calendar.badge.minus" : "calendar.badge.plus",
                                title: isFullDayBlocked ? "Remove Full Day Leave" : "Mark Full Day Leave",
                                color: leaveColor,
                                action: {
                                    toggleFullDayLeave(for: selectedDate)
                                }
                            )
                            
                            Spacer()
                            
                            // Quick Actions Menu
                            Menu {
                                Button(action: {
                                    blockMorningSlots()
                                }) {
                                    Label("Mark Morning Leave", systemImage: "sunrise")
                                }
                                
                                Button(action: {
                                    blockAfternoonSlots()
                                }) {
                                    Label("Mark Afternoon Leave", systemImage: "sunset")
                                }
                                
                                Button(action: {
                                    clearAllSlots()
                                }) {
                                    Label("Clear All Leaves", systemImage: "trash")
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "ellipsis.circle.fill")
                                    Text("Actions")
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Time Slots Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Manage Time Slots")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.text)
                                
                                if fullDayLeaves.contains(selectedDate) {
                                    Spacer()
                                    Text("Full Day Leave")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(redLeaveColor)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Morning slots
                            SlotSection(
                                title: "Morning Slots",
                                icon: "sunrise.fill",
                                slots: Array(timeSlots.prefix(6)),
                                blockedSlots: leaveTimeSlots[selectedDate, default: []],
                                isFullDayBlocked: fullDayLeaves.contains(selectedDate),
                                leaveColor: redLeaveColor,
                                mainColor: leaveColor,
                                theme: theme,
                                onToggle: { slot in
                                    toggleTimeSlot(for: selectedDate, time: slot)
                                }
                            )
                            
                            // Afternoon slots
                            SlotSection(
                                title: "Afternoon Slots",
                                icon: "sunset.fill",
                                slots: Array(timeSlots.suffix(6)),
                                blockedSlots: leaveTimeSlots[selectedDate, default: []],
                                isFullDayBlocked: fullDayLeaves.contains(selectedDate),
                                leaveColor: redLeaveColor,
                                mainColor: leaveColor,
                                theme: theme,
                                onToggle: { slot in
                                    toggleTimeSlot(for: selectedDate, time: slot)
                                }
                            )
                        }
                        .padding(.top, 8)
                        
                        Spacer(minLength: 15)
                    }
                    
                    
                    // Bottom buttons
                    .safeAreaInset(edge: .bottom) {
                        HStack(spacing: 16) {
                            // Undo button
                            Button(action: {
                                undoLastAction()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("Undo")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(lastAction != nil ? leaveColor.opacity(0.1) : Color.gray.opacity(0.1))
                                .foregroundColor(lastAction != nil ? leaveColor : .gray)
                                .cornerRadius(20)
                            }
                            .disabled(lastAction == nil)
                            
                            // Save button
                            Button(action: {
                                showSuccessToast = true
                                lastAction = nil
                                actionType = .none
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showSuccessToast = false
                                }
                            }) {
                                Text("Save Changes")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(leaveColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        .padding()
                        .background(theme.background) // Updated to use theme background
                    }
                }
            }
            
            // Toast message
            if showSuccessToast {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(leaveColor)
                        Text("Leave schedule saved successfully!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(theme.text)
                        Spacer()
                    }
                    .padding()
                    .background(theme.card)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
            }
            
            // Date picker sheet
            if showDatePicker {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDatePicker = false
                    }
                
                DatePickerView(
                    selectedDate: $selectedDate,
                    fullDayLeaves: fullDayLeaves,
                    isShowing: $showDatePicker,
                    theme: theme,
                    leaveColor: redLeaveColor
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showDatePicker)
            }
        }
        .background(theme.background)
        .alert(isPresented: $showUndoAlert) {
            Alert(
                title: Text("Changes Undone"),
                message: Text("Your previous leave changes have been reversed."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func toggleTimeSlot(for date: Date, time: String) {
        // Save current state for undo
        let currentSlots = leaveTimeSlots[date, default: []]
        lastAction = (date: date, slots: currentSlots)
        actionType = .blockSlot
        
        // Apply the change
        var set = currentSlots
        if set.contains(time) {
            set.remove(time)
        } else {
            set.insert(time)
        }
        leaveTimeSlots[date] = set
    }
    
    func toggleFullDayLeave(for date: Date) {
        // Save current state for undo
        let currentSlots = leaveTimeSlots[date, default: []]
        lastAction = (date: date, slots: currentSlots)
        actionType = .blockFullDay
        
        // Apply the change
        if fullDayLeaves.contains(date) {
            fullDayLeaves.remove(date)
            leaveTimeSlots[date] = []
        } else {
            fullDayLeaves.insert(date)
            leaveTimeSlots[date] = Set(timeSlots)
        }
    }
    
    func blockMorningSlots() {
        // Save current state for undo
        let currentSlots = leaveTimeSlots[selectedDate, default: []]
        lastAction = (date: selectedDate, slots: currentSlots)
        actionType = .blockSlot
        
        // Add morning slots to blocked slots
        var set = currentSlots
        for slot in timeSlots.prefix(6) {
            set.insert(slot)
        }
        leaveTimeSlots[selectedDate] = set
    }
    
    func blockAfternoonSlots() {
        // Save current state for undo
        let currentSlots = leaveTimeSlots[selectedDate, default: []]
        lastAction = (date: selectedDate, slots: currentSlots)
        actionType = .blockSlot
        
        // Add afternoon slots to blocked slots
        var set = currentSlots
        for slot in timeSlots.suffix(6) {
            set.insert(slot)
        }
        leaveTimeSlots[selectedDate] = set
    }
    
    func clearAllSlots() {
        // Save current state for undo
        let currentSlots = leaveTimeSlots[selectedDate, default: []]
        lastAction = (date: selectedDate, slots: currentSlots)
        actionType = .blockSlot
        
        // Clear all slots for the selected date
        if fullDayLeaves.contains(selectedDate) {
            fullDayLeaves.remove(selectedDate)
        }
        leaveTimeSlots[selectedDate] = []
    }
    
    func undoLastAction() {
        guard let lastAction = lastAction else { return }
        
        switch actionType {
        case .blockFullDay:
            if fullDayLeaves.contains(lastAction.date) {
                fullDayLeaves.remove(lastAction.date)
            } else {
                fullDayLeaves.insert(lastAction.date)
            }
        case .blockSlot:
            // Just restore the previous state
            break
        case .none:
            return
        }
        
        leaveTimeSlots[lastAction.date] = lastAction.slots
        self.lastAction = nil
        actionType = .none
        showUndoAlert = true
    }
}

// MARK: - DatePickerView
struct DatePickerView: View {
    @Binding var selectedDate: Date
    let fullDayLeaves: Set<Date>
    @Binding var isShowing: Bool
    let theme: Theme
    let leaveColor: Color
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Select Date")
                    .font(.headline)
                    .foregroundColor(theme.text)
                
                Spacer()
                
                Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Date Picker
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .accentColor(theme.primary)
            
            // Apply button
            Button(action: {
                isShowing = false
            }) {
                Text("Apply")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.card)
                .shadow(radius: 10)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(20)
        }
    }
}

// MARK: - Slot Section
struct SlotSection: View {
    let title: String
    let icon: String
    let slots: [String]
    let blockedSlots: Set<String>
    let isFullDayBlocked: Bool
    let leaveColor: Color
    let mainColor: Color
    let theme: Theme
    let onToggle: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(mainColor)
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(mainColor)
            }
            .padding(.horizontal)
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(slots, id: \.self) { slot in
                    SlotToggleButton(
                        time: slot,
                        isBlocked: blockedSlots.contains(slot) || isFullDayBlocked,
                        fullDayBlock: isFullDayBlocked,
                        leaveColor: leaveColor,
                        theme: theme,
                        onToggle: {
                            onToggle(slot)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Slot Toggle Button
struct SlotToggleButton: View {
    let time: String
    let isBlocked: Bool
    let fullDayBlock: Bool
    let leaveColor: Color
    let theme: Theme
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: fullDayBlock ? {} : onToggle) {
            HStack {
                Text(time)
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(theme.text)
                Spacer()
                Image(systemName: isBlocked ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(isBlocked ? leaveColor : .green)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isBlocked ? leaveColor.opacity(0.08) : Color.green.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(isBlocked ? leaveColor.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
            .opacity(fullDayBlock ? 0.6 : 1)
        }
        .disabled(fullDayBlock)
    }
}


// MARK: - Preview
struct DoctorSlotManagerView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSlotManagerView()
    }
}


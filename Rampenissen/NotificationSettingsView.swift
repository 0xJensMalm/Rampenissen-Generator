
//  NotificationSettingsView.swift
//  Rampenissen
//
//  Created by Jens Aga Malm on 09/12/2023.
//

import Foundation
import SwiftUI
import UserNotifications

// NotificationSettingsView.swift
struct NotificationSettingsView: View {
  @Binding var show: Bool
  @Binding var reminderSet: Bool
  @Binding var selectedTime: Date

  var body: some View {
    VStack(spacing: 20) {
      Text("Daglig påminnelse klokken:")
        .font(.headline)

      DatePicker("Velg tid:", selection: $selectedTime, displayedComponents: .hourAndMinute)
        .labelsHidden()

      HStack {
        Button("Avbryt påminnelse") {
          cancelReminder()
          show = false
        }
        .padding()

        Button("Sett påminnelse") {
          setReminder()
          show = false
        }
        .padding()
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(10)
    .shadow(radius: 10)
  }

  private func setReminder() {
    requestNotificationPermission()
    scheduleDailyNotification(at: selectedTime)
    reminderSet = true
    saveReminderState()
  }

  private func cancelReminder() {
    reminderSet = false
    selectedTime = Date()
    saveReminderState()
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }

  private func saveReminderState() {
    UserDefaults.standard.set(reminderSet, forKey: UserDefaultsKeys.reminderSet)
    UserDefaults.standard.set(selectedTime, forKey: UserDefaultsKeys.selectedTime)
  }

  private func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
      // Handle the permission granted or not
    }
  }

  private func scheduleDailyNotification(at time: Date) {
    let content = UNMutableNotificationContent()
    content.title = "Husk å rigge rampenissen"
    content.body = "Bruk rampenissen appen for ideer!"
    content.sound = UNNotificationSound.default

    var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
    dateComponents.second = 0
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(
      identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
}

struct NotificationSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationSettingsView(show: .constant(true), reminderSet: .constant(false), selectedTime: .constant(Date()))
  }
}

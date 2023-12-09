import SwiftUI
import AVFoundation

struct Activities: Codable {
    let Min: [String]
    let Medium: [String]
    let Long: [String]
}

struct ContentView: View {
    @ObservedObject var globalSettings = GlobalSettings.shared

    @State private var selectedDuration = "1 min"
    @State private var randomActivityDescription = ""
    @State private var isSavageModeActive = false
    @State private var isButtonPressed = false
    @State private var showCustomAlert = false
    @State private var showPurchasePrompt = false
    @State private var showNotificationSettings = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image(isSavageModeActive ? "SavageBackground" : "background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Title Image
                    Image("generatortitle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .padding(.top, -10)

                    Spacer()

                    // Toggles and Button
                    Text("Hvor mye tid gidder du å bruke?")
                        .font(.title3)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 0)
                        .padding()

                    // Toggles for activity duration
                    Picker("Duration", selection: $selectedDuration) {
                                            Text("1 min").tag("1 min")
                                            Text("5 min").tag("5 min")
                                            Text("10+ min").tag("10+ min")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                    // Main Button
                    Button(action: {
                        generateActivity()
                    }) {
                        Image(isSavageModeActive ? "SavageButton" : "bigredbutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.8)
                            .scaleEffect(isButtonPressed ? 0.85 : 1.0)
                    }
                    .padding(.bottom)
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.001).onChanged { _ in
                            withAnimation(.easeIn) { self.isButtonPressed = true }
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut) { self.isButtonPressed = false }
                        }
                    )

                    Spacer()

                    // Custom navigation bar
                    CustomNavigationBar(isProVersionPurchased: $globalSettings.isProVersionPurchased,
                        isSavageModeActive: $isSavageModeActive,
                        showPurchasePrompt: $showPurchasePrompt,
                        showNotificationSettings: $showNotificationSettings,
                        reminderSet: globalSettings.reminderSet,
                        selectedTime: globalSettings.selectedTime)

                }  // End of VStack

                // Custom Alert Views
                if showCustomAlert {
                    CustomAlertView(title: "Rampestrek:", message: randomActivityDescription, dismissButtonTitle: "OK", dismissAction: { showCustomAlert = false })
                }

                if showPurchasePrompt {
                    PurchasePromptView(showPurchasePrompt: $showPurchasePrompt, isProVersionPurchased: $globalSettings.isProVersionPurchased)
                }

                if showNotificationSettings {
                    NotificationSettingsView(show: $showNotificationSettings, reminderSet: $globalSettings.reminderSet, selectedTime: $globalSettings.selectedTime)
                }
            }  // End of ZStack
            .edgesIgnoringSafeArea(.bottom)
        }  // End of GeometryReader
    }  // End of ContentView

    private func generateActivity() {
           DispatchQueue.main.async {
               if let activities = loadActivities() {
                   var allActivities: [String] = []

                   // Use selectedDuration to determine which activities to fetch
                   switch selectedDuration {
                   case "1 min":
                       allActivities += activities.Min
                   case "5 min":
                       allActivities += activities.Medium
                   case "10+ min":
                       allActivities += activities.Long
                   default:
                       break
                   }

                if allActivities.isEmpty {
                    self.randomActivityDescription = "Vennligst velg hvor mye tid du gidder å bruke"
                    self.showCustomAlert = true
                } else if let randomActivity = allActivities.randomElement() {
                    self.randomActivityDescription = randomActivity
                    self.showCustomAlert = true
                }
            }
        }
    }

    private func loadActivities() -> Activities? {
        let resourceName = isSavageModeActive ? "savageData" : "Data"
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "geojson"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load \(resourceName).geojson from bundle.")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode(Activities.self, from: data)
            return jsonData
        } catch {
            print("Failed to decode Activities from \(resourceName).geojson: \(error)")
            return nil
        }
    }
}
// MARK: - Supporting Views and Styles

struct CustomAlertView: View {
    var title: String
    var message: String
    var dismissButtonTitle: String
    var dismissAction: () -> Void
    var purchaseAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text(title).font(.headline)
            Text(message)
            Button(dismissButtonTitle, action: dismissAction)
                .foregroundColor(.blue)

            if let purchaseAction = purchaseAction {
                Button("Kjøp Rampenissen PRO", action: purchaseAction)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}

struct PlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
// MARK: - Custom Navigation Bar

struct CustomNavigationBar: View {
    @Binding var isProVersionPurchased: Bool
    @Binding var isSavageModeActive: Bool
    @Binding var showPurchasePrompt: Bool
    @Binding var showNotificationSettings: Bool
    var reminderSet: Bool // Changed to regular Bool
    var selectedTime: Date // Changed to regular Date

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer(minLength: geometry.size.width * 0.25 - 24)
                
                // Savage mode toggle button
                Button(action: {
                    if isProVersionPurchased {
                        isSavageModeActive.toggle()
                    } else {
                        showPurchasePrompt = true
                    }
                }) {
                    Image(systemName: isSavageModeActive ? "flame.fill" : "flame")
                        .foregroundColor(isSavageModeActive ? .orange : .white)
                        .imageScale(.large)
                }

                Spacer()

                // Coffee icon (Placeholder for future functionality)
                Button(action: {
                    // Future action for donation page or in-game purchase
                }) {
                    Image(systemName: "cup.and.saucer.fill")
                        .imageScale(.large)
                }

                Spacer()

                // Bell icon for notifications
                Button(action: {
                    if isProVersionPurchased {
                        showNotificationSettings = true
                    } else {
                        showPurchasePrompt = true
                    }
                }) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(reminderSet ? .orange : .white)
                        .imageScale(.large)
                    if reminderSet {
                        Text(GlobalSettings.reminderTimeText(from: selectedTime))
                            .foregroundColor(.white)

                    }
                }

                Spacer(minLength: geometry.size.width * 0.25 - 24)
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
    }
}

// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

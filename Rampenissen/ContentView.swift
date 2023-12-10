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
    @State private var showPopUp = false


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image(isSavageModeActive ? "SavageBackground" : "dopeBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Title Image
                    Image("dopeTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .padding(.top, 10)

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
                        Image(isSavageModeActive ? "savageButton" : "vectorButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.8)
                            .scaleEffect(isButtonPressed ? 0.1 : 1.0)
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
    var reminderSet: Bool
    var selectedTime: Date
    @State private var showThankYouAlert = false

    var body: some View {
        HStack {
            Spacer()
            
            // Savage mode toggle button
            VStack {
                Text(isSavageModeActive ? "Savage-mode" : "")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .frame(height: 20) // Fixed frame height to avoid pushing the icon
                Button(action: {
                    isSavageModeActive.toggle()
                }) {
                    Image(systemName: isSavageModeActive ? "flame.fill" : "flame")
                        .foregroundColor(isSavageModeActive ? .orange : .white)
                        .imageScale(.large)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 4)
            
            Spacer()
            
            // Coffee icon (for future functionality)
            VStack {
                Text(isProVersionPurchased ? "PRO" : "")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .frame(height: 20) // Fixed frame height to avoid pushing the icon
                Button(action: {
                    if isProVersionPurchased {
                        // Show thank you message
                        self.showThankYouAlert = true
                    } else {
                        // Show purchase prompt
                        showPurchasePrompt = true
                    }
                }) {
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundColor(isProVersionPurchased ? .orange : .white)
                        .imageScale(.large)
                }
            }
            .alert(isPresented: $showThankYouAlert) {
                Alert(
                    title: Text("Tusen takk!"),
                    message: Text("Takk for at du støtter appen. God jul!."),
                    dismissButton: .default(Text("Selv takk!"))
                )
            }
            .frame(width: UIScreen.main.bounds.width / 4)

            Spacer()

            
            // Bell icon for notifications
            VStack(spacing: 0) {
                if reminderSet {
                    Text(GlobalSettings.reminderTimeText(from: selectedTime))
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Spacer().frame(height: 20) // Keep space consistent
                }

                Button(action: {
                    // Trigger the display of the notification settings
                    showNotificationSettings.toggle()
                }) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(reminderSet ? .orange : .white)
                        .imageScale(.large)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 4)
            
            Spacer()
        }
        .padding([.top, .horizontal])
        .background(Color.black)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottom) // Set a fixed height for the navigation bar
        .edgesIgnoringSafeArea(.bottom) // Ensuring it stays at the bottom across all devices
    }
}



// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

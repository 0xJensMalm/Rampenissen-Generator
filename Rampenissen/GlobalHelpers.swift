import Foundation

public class GlobalSettings: ObservableObject {
    @Published public var isProVersionPurchased: Bool {
        didSet {
            UserDefaults.standard.set(isProVersionPurchased, forKey: UserDefaultsKeys.isProVersionPurchased)
        }
    }
    
    @Published public var reminderSet: Bool {
        didSet {
            UserDefaults.standard.set(reminderSet, forKey: UserDefaultsKeys.reminderSet)
        }
    }
    
    @Published public var selectedTime: Date {
        didSet {
            UserDefaults.standard.set(selectedTime, forKey: UserDefaultsKeys.selectedTime)
        }
    }
    
    public init() {
        self.isProVersionPurchased = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isProVersionPurchased)
        self.reminderSet = UserDefaults.standard.bool(forKey: UserDefaultsKeys.reminderSet)
        self.selectedTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.selectedTime) as? Date ?? Date()
    }
    
    public static let shared = GlobalSettings()

    public static func reminderTimeText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

public struct UserDefaultsKeys {
    public static let isProVersionPurchased = "isProVersionPurchased"
    public static let reminderSet = "reminderSet"
    public static let selectedTime = "selectedTime"
}

import Foundation
import SwiftUI
import Observation

// MARK: - AppTheme Enum
enum AppTheme: String, Codable, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

// MARK: - SettingsStore
@Observable
class SettingsStore {
    // MARK: - Storage Keys
    private enum Keys {
        static let notifications = "settings.notifications.enabled"
        static let sound = "settings.sound.enabled"
        static let haptics = "settings.haptics.enabled"
        static let autoPlay = "settings.autoplay.enabled"
        static let dataSync = "settings.datasync.enabled"
        static let theme = "settings.theme"
    }

    // MARK: - Dependencies
    private let userDefaults: UserDefaults

    // MARK: - Observable Properties
    var notificationsEnabled: Bool {
        didSet {
            userDefaults.set(notificationsEnabled, forKey: Keys.notifications)
        }
    }

    var soundEnabled: Bool {
        didSet {
            userDefaults.set(soundEnabled, forKey: Keys.sound)
        }
    }

    var hapticsEnabled: Bool {
        didSet {
            userDefaults.set(hapticsEnabled, forKey: Keys.haptics)
        }
    }

    var autoPlayVideos: Bool {
        didSet {
            userDefaults.set(autoPlayVideos, forKey: Keys.autoPlay)
        }
    }

    var dataSyncEnabled: Bool {
        didSet {
            userDefaults.set(dataSyncEnabled, forKey: Keys.dataSync)
        }
    }

    var selectedTheme: AppTheme {
        didSet {
            userDefaults.set(selectedTheme.rawValue, forKey: Keys.theme)
        }
    }

    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        // Load from storage or use defaults
        self.notificationsEnabled = userDefaults.object(forKey: Keys.notifications) as? Bool ?? true
        self.soundEnabled = userDefaults.object(forKey: Keys.sound) as? Bool ?? true
        self.hapticsEnabled = userDefaults.object(forKey: Keys.haptics) as? Bool ?? true
        self.autoPlayVideos = userDefaults.object(forKey: Keys.autoPlay) as? Bool ?? false
        self.dataSyncEnabled = userDefaults.object(forKey: Keys.dataSync) as? Bool ?? true

        // Load theme with fallback to default
        if let themeString = userDefaults.string(forKey: Keys.theme),
           let theme = AppTheme(rawValue: themeString) {
            self.selectedTheme = theme
        } else {
            self.selectedTheme = .system
        }
    }
}

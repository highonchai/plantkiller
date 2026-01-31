import SwiftUI

// MARK: - Settings View
// App settings and preferences

struct SettingsView: View {
    @Bindable var appViewModel: AppViewModel
    let onDismiss: () -> Void

    @State private var notificationTime: Date = UserPreferences.shared.notificationTime
    @State private var showingResetConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                // Notifications Section
                Section {
                    // Notification status
                    HStack {
                        SettingsIcon(icon: "bell.fill", color: Theme.Colors.statusYellow)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Notifications")
                                .font(Theme.Typography.bodyMedium)

                            Text(appViewModel.notificationsEnabled ? "Enabled" : "Disabled")
                                .font(Theme.Typography.caption)
                                .foregroundColor(appViewModel.notificationsEnabled ? Theme.Colors.statusGreen : Theme.Colors.statusRed)
                        }

                        Spacer()

                        if !appViewModel.notificationsEnabled {
                            Button("Enable") {
                                openSettings()
                            }
                            .font(Theme.Typography.labelMedium)
                            .foregroundColor(Theme.Colors.primaryDark)
                        }
                    }

                    // Reminder time
                    HStack {
                        SettingsIcon(icon: "clock.fill", color: Theme.Colors.primaryDark)

                        DatePicker(
                            "Reminder Time",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: notificationTime) { _, newValue in
                            UserPreferences.shared.notificationTime = newValue
                        }
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("We'll send you a daily reminder at this time if any plants need water.")
                }

                // Subscription Section
                Section {
                    HStack {
                        SettingsIcon(icon: "crown.fill", color: Theme.Colors.statusYellow)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Subscription")
                                .font(Theme.Typography.bodyMedium)

                            Text(UserPreferences.shared.isPremium ? "Premium" : "Free Plan")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        Spacer()

                        if !UserPreferences.shared.isPremium {
                            Button("Upgrade") {
                                appViewModel.showPaywall()
                            }
                            .font(Theme.Typography.labelMedium)
                            .foregroundColor(Theme.Colors.primaryDark)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.Colors.statusGreen)
                        }
                    }

                    if !UserPreferences.shared.isPremium {
                        Button(action: { appViewModel.restorePurchases() }) {
                            HStack {
                                SettingsIcon(icon: "arrow.clockwise", color: Theme.Colors.textSecondary)
                                Text("Restore Purchases")
                                    .font(Theme.Typography.bodyMedium)
                            }
                        }
                        .foregroundColor(Theme.Colors.textPrimary)
                    }
                } header: {
                    Text("Subscription")
                } footer: {
                    if UserPreferences.shared.isPremium {
                        Text("Thank you for supporting PlantKiller!")
                    } else {
                        Text("Free plan includes up to 2 plants. Upgrade for unlimited plants.")
                    }
                }

                // Progress Section
                Section {
                    HStack {
                        SettingsIcon(icon: "chart.line.uptrend.xyaxis", color: Theme.Colors.statusGreen)

                        Text("Longest Survival")
                            .font(Theme.Typography.bodyMedium)

                        Spacer()

                        Text("\(UserPreferences.shared.longestPlantSurvival) days")
                            .font(Theme.Typography.bodyMedium)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }

                    HStack {
                        SettingsIcon(icon: "xmark.circle", color: Theme.Colors.statusRed)

                        Text("Total Plants Lost")
                            .font(Theme.Typography.bodyMedium)

                        Spacer()

                        Text("\(UserPreferences.shared.totalPlantsKilled)")
                            .font(Theme.Typography.bodyMedium)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }

                    HStack {
                        SettingsIcon(icon: "star.fill", color: Theme.Colors.tierIntermediate)

                        Text("Highest Tier Unlocked")
                            .font(Theme.Typography.bodyMedium)

                        Spacer()

                        TierBadge(tier: UserPreferences.shared.highestUnlockedTier, size: .small)
                    }
                } header: {
                    Text("Your Progress")
                }

                // About Section
                Section {
                    Link(destination: URL(string: "mailto:support@plantkiller.app")!) {
                        HStack {
                            SettingsIcon(icon: "envelope.fill", color: Theme.Colors.primaryDark)
                            Text("Contact Support")
                                .font(Theme.Typography.bodyMedium)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.Colors.textTertiary)
                        }
                    }
                    .foregroundColor(Theme.Colors.textPrimary)

                    Link(destination: URL(string: "https://plantkiller.app/privacy")!) {
                        HStack {
                            SettingsIcon(icon: "hand.raised.fill", color: Theme.Colors.textSecondary)
                            Text("Privacy Policy")
                                .font(Theme.Typography.bodyMedium)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.Colors.textTertiary)
                        }
                    }
                    .foregroundColor(Theme.Colors.textPrimary)

                    Link(destination: URL(string: "https://plantkiller.app/terms")!) {
                        HStack {
                            SettingsIcon(icon: "doc.text.fill", color: Theme.Colors.textSecondary)
                            Text("Terms of Service")
                                .font(Theme.Typography.bodyMedium)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.Colors.textTertiary)
                        }
                    }
                    .foregroundColor(Theme.Colors.textPrimary)

                    HStack {
                        SettingsIcon(icon: "info.circle.fill", color: Theme.Colors.textTertiary)

                        Text("Version")
                            .font(Theme.Typography.bodyMedium)

                        Spacer()

                        Text("1.0.0")
                            .font(Theme.Typography.bodyMedium)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                } header: {
                    Text("About")
                }

                // Danger Zone
                Section {
                    Button(action: { showingResetConfirmation = true }) {
                        HStack {
                            SettingsIcon(icon: "trash.fill", color: Theme.Colors.statusRed)
                            Text("Reset All Data")
                                .font(Theme.Typography.bodyMedium)
                        }
                    }
                    .foregroundColor(Theme.Colors.statusRed)
                } header: {
                    Text("Danger Zone")
                } footer: {
                    Text("This will delete all your plants and reset your progress. This cannot be undone.")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: onDismiss)
                        .font(Theme.Typography.labelLarge)
                        .foregroundColor(Theme.Colors.primaryDark)
                }
            }
            .confirmationDialog(
                "Reset All Data",
                isPresented: $showingResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Everything", role: .destructive) {
                    DataService.shared.clearAllData()
                    appViewModel.plantsViewModel.loadPlants()
                    appViewModel.graveyardViewModel.loadEntries()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all your plants, graveyard entries, and reset your progress. This action cannot be undone.")
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Settings Icon

struct SettingsIcon: View {
    let icon: String
    let color: Color

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(color)
            .frame(width: 28, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.15))
            )
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        appViewModel: AppViewModel.shared,
        onDismiss: {}
    )
}

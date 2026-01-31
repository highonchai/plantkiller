import SwiftUI

// MARK: - Plant Detail View
// Full detail card for a plant

struct PlantDetailView: View {
    let plant: Plant
    let onWater: () -> Void
    let onDelete: () -> Void
    let onKill: () -> Void
    let onUpdate: (Plant) -> Void
    let onDismiss: () -> Void

    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedWateringDays: Int = 7
    @State private var showingDeleteConfirmation = false
    @State private var showingKillConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Plant image
                    AnimatedPlantImageView(plantTypeId: plant.plantTypeId, size: .extraLarge)
                        .padding(.top, Theme.Spacing.lg)

                    // Plant name and type
                    VStack(spacing: Theme.Spacing.xs) {
                        if isEditing {
                            TextField("Plant name", text: $editedName)
                                .font(Theme.Typography.displaySmall)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.plain)
                                .padding(.horizontal, Theme.Spacing.lg)
                        } else {
                            Text(plant.name)
                                .font(Theme.Typography.displaySmall)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }

                        if let plantType = plant.plantType {
                            Text(plantType.commonName)
                                .font(Theme.Typography.bodyMedium)
                                .foregroundColor(Theme.Colors.textSecondary)

                            TierBadge(tier: plantType.tier, size: .small)
                                .padding(.top, Theme.Spacing.xxs)
                        }
                    }

                    // Warning badge info
                    if plant.hasWarningBadge {
                        InfoBanner(
                            icon: "exclamationmark.triangle.fill",
                            title: "Above your skill level",
                            subtitle: "This plant was added before you unlocked its tier",
                            backgroundColor: Theme.Colors.statusYellow.opacity(0.1),
                            borderColor: Theme.Colors.statusYellow,
                            iconColor: Theme.Colors.statusYellow
                        )
                        .padding(.horizontal, Theme.Spacing.screenPadding)
                    }

                    // Status card
                    StatusCard(plant: plant, isEditing: isEditing, editedDays: $editedWateringDays)
                        .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Care tips
                    if let plantType = plant.plantType {
                        CareTipsCard(plantType: plantType)
                            .padding(.horizontal, Theme.Spacing.screenPadding)
                    }

                    // Stats card
                    StatsCard(plant: plant)
                        .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Action buttons
                    if !isEditing {
                        VStack(spacing: Theme.Spacing.md) {
                            WateringButton(plant: plant, onWater: onWater)

                            HStack(spacing: Theme.Spacing.md) {
                                Button(action: { showingKillConfirmation = true }) {
                                    HStack {
                                        Image(systemName: "xmark.circle")
                                        Text("Mark as Dead")
                                    }
                                }
                                .buttonStyle(DestructiveButtonStyle())

                                Button(action: { showingDeleteConfirmation = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                }
                                .buttonStyle(DestructiveButtonStyle())
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.screenPadding)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .background(Theme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleEdit) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(Theme.Typography.labelLarge)
                            .foregroundColor(Theme.Colors.primaryDark)
                    }
                }
            }
            .onAppear {
                editedName = plant.name
                editedWateringDays = plant.wateringIntervalDays
            }
            .confirmationDialog(
                "Delete Plant",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will move \(plant.name) to the graveyard. You have 7 days to resurrect it.")
            }
            .confirmationDialog(
                "Mark as Dead",
                isPresented: $showingKillConfirmation,
                titleVisibility: .visible
            ) {
                Button("Mark as Dead", role: .destructive) {
                    onKill()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("R.I.P. \(plant.name). It will be remembered in the graveyard.")
            }
        }
    }

    private func toggleEdit() {
        if isEditing {
            // Save changes
            var updatedPlant = plant
            updatedPlant.name = editedName.isEmpty ? plant.name : editedName
            updatedPlant.wateringIntervalDays = editedWateringDays
            onUpdate(updatedPlant)
        }
        isEditing.toggle()
    }
}

// MARK: - Status Card

struct StatusCard: View {
    let plant: Plant
    var isEditing: Bool = false
    @Binding var editedDays: Int

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Text("Status")
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)

                Spacer()

                StatusIndicator(status: plant.status, size: .medium, showLabel: true)
            }

            Divider()

            // Last watered
            HStack {
                Label("Last Watered", systemImage: "clock")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)

                Spacer()

                Text(plant.lastWateredText)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
            }

            // Next watering
            HStack {
                Label("Next Watering", systemImage: "calendar")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)

                Spacer()

                Text(plant.nextWateringText)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(statusColor)
            }

            // Watering schedule (editable)
            HStack {
                Label("Schedule", systemImage: "repeat")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)

                Spacer()

                if isEditing {
                    Picker("Days", selection: $editedDays) {
                        ForEach([1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30], id: \.self) { days in
                            Text(scheduleText(days)).tag(days)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Theme.Colors.primaryDark)
                } else {
                    Text(scheduleText(plant.wateringIntervalDays))
                        .font(Theme.Typography.bodyMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
            }
        }
        .padding(Theme.Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                .fill(Theme.Colors.cardBackground)
                .themeShadow(Theme.Shadows.card)
        )
    }

    private var statusColor: Color {
        switch plant.status {
        case .healthy: return Theme.Colors.statusGreen
        case .needsWater: return Theme.Colors.statusYellow
        case .critical: return Theme.Colors.statusRed
        }
    }

    private func scheduleText(_ days: Int) -> String {
        switch days {
        case 1: return "Daily"
        case 7: return "Weekly"
        case 14: return "Every 2 weeks"
        default: return "Every \(days) days"
        }
    }
}

// MARK: - Care Tips Card

struct CareTipsCard: View {
    let plantType: PlantType

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.statusYellow)

                Text("Care Tips")
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Text(plantType.careTips)
                .font(Theme.Typography.bodyMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Theme.Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                .fill(Theme.Colors.cardBackground)
                .themeShadow(Theme.Shadows.card)
        )
    }
}

// MARK: - Stats Card

struct StatsCard: View {
    let plant: Plant

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Text("Statistics")
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)

                Spacer()
            }

            HStack(spacing: Theme.Spacing.xl) {
                StatItem(value: "\(plant.daysAlive)", label: "Days Alive")
                StatItem(value: "\(plant.daysSinceLastWatered)", label: "Days Since Water")
            }
        }
        .padding(Theme.Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                .fill(Theme.Colors.cardBackground)
                .themeShadow(Theme.Shadows.card)
        )
    }
}

struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: Theme.Spacing.xxs) {
            Text(value)
                .font(Theme.Typography.displaySmall)
                .foregroundColor(Theme.Colors.primaryDark)

            Text(label)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    PlantDetailView(
        plant: Plant.samplePlants[0],
        onWater: {},
        onDelete: {},
        onKill: {},
        onUpdate: { _ in },
        onDismiss: {}
    )
}

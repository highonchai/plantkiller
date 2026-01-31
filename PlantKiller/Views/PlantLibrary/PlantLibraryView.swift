import SwiftUI

// MARK: - Plant Library View
// Shows all available plants organized by tier

struct PlantLibraryView: View {
    @Bindable var viewModel: PlantLibraryViewModel
    let onAddPlant: (Plant) -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    // Info banner
                    InfoBanner(
                        icon: "info.circle.fill",
                        title: "Choose your plant",
                        subtitle: "Unlock more plants by keeping yours alive!"
                    )
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Plant list by tier
                    ForEach(viewModel.availableTiers, id: \.self) { tier in
                        VStack(spacing: Theme.Spacing.sm) {
                            TierSectionHeader(
                                tier: tier,
                                isUnlocked: viewModel.isTierUnlocked(tier),
                                plantCount: viewModel.plants(forTier: tier).count
                            )

                            ForEach(viewModel.plants(forTier: tier)) { plantType in
                                PlantTypeCardView(
                                    plantType: plantType,
                                    isUnlocked: viewModel.isPlantUnlocked(plantType),
                                    onTap: { viewModel.selectPlant(plantType) }
                                )
                                .padding(.horizontal, Theme.Spacing.screenPadding)
                            }
                        }
                    }
                }
                .padding(.vertical, Theme.Spacing.lg)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Plant Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: onDismiss)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            .sheet(isPresented: $viewModel.showingPlantInfo) {
                if let plantType = viewModel.selectedPlantType {
                    PlantInfoSheet(
                        plantType: plantType,
                        viewModel: viewModel,
                        onProceed: { viewModel.proceedToSchedule() },
                        onCancel: { viewModel.cancelSelection() }
                    )
                    .presentationDetents([.medium, .large])
                }
            }
            .sheet(isPresented: $viewModel.showingScheduleSetup) {
                if let plantType = viewModel.selectedPlantType {
                    ScheduleSetupSheet(
                        plantType: plantType,
                        viewModel: viewModel,
                        onComplete: { handleAddPlant() },
                        onCancel: { viewModel.cancelSelection() }
                    )
                    .presentationDetents([.medium])
                }
            }
            .alert("Unlock Required", isPresented: $viewModel.showingBypassWarning) {
                Button("I Already Own This") {
                    viewModel.confirmBypass()
                }
                Button("Cancel", role: .cancel) {
                    viewModel.cancelBypass()
                }
            } message: {
                if let plantType = viewModel.selectedPlantType {
                    Text("\(plantType.commonName) is a \(plantType.tier.displayName) plant. To unlock it normally: \(plantType.tier.unlockRequirement)\n\nIf you already own this plant, you can add it anyway, but it will show a warning badge.")
                }
            }
        }
    }

    private func handleAddPlant() {
        if let plant = viewModel.createPlant() {
            onAddPlant(plant)
            onDismiss()
        }
    }
}

// MARK: - Plant Info Sheet

struct PlantInfoSheet: View {
    let plantType: PlantType
    @Bindable var viewModel: PlantLibraryViewModel
    let onProceed: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Plant image
                    PlantImageView(plantTypeId: plantType.id, size: .large)
                        .padding(.top, Theme.Spacing.lg)

                    // Plant info
                    VStack(spacing: Theme.Spacing.xs) {
                        Text(plantType.commonName)
                            .font(Theme.Typography.displaySmall)
                            .foregroundColor(Theme.Colors.textPrimary)

                        Text(plantType.scientificName)
                            .font(Theme.Typography.bodyMedium)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .italic()

                        HStack(spacing: Theme.Spacing.md) {
                            TierBadge(tier: plantType.tier)
                            DifficultyStars(tier: plantType.tier)
                        }
                        .padding(.top, Theme.Spacing.xs)
                    }

                    // Bypass warning
                    if viewModel.bypassConfirmed {
                        InfoBanner(
                            icon: "exclamationmark.triangle.fill",
                            title: "Above your skill level",
                            subtitle: "This plant will show a warning badge",
                            backgroundColor: Theme.Colors.statusYellow.opacity(0.1),
                            borderColor: Theme.Colors.statusYellow,
                            iconColor: Theme.Colors.statusYellow
                        )
                        .padding(.horizontal, Theme.Spacing.screenPadding)
                    }

                    // Details card
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        DetailRow(icon: "drop.fill", label: "Watering", value: plantType.wateringFrequencyText)
                        Divider()
                        DetailRow(icon: "star.fill", label: "Difficulty", value: plantType.tier.displayName)
                        Divider()

                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Theme.Colors.statusYellow)
                                Text("Care Tips")
                                    .font(Theme.Typography.labelMedium)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }

                            Text(plantType.careTips)
                                .font(Theme.Typography.bodyMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                    }
                    .padding(Theme.Spacing.cardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                            .fill(Theme.Colors.cardBackground)
                            .themeShadow(Theme.Shadows.card)
                    )
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Description
                    Text(plantType.description)
                        .font(Theme.Typography.bodyMedium)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.xl)

                    // Add button
                    Button(action: onProceed) {
                        Text("Add This Plant")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, Theme.Spacing.screenPadding)
                    .padding(.bottom, Theme.Spacing.xl)
                }
            }
            .background(Theme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: icon)
                    .foregroundColor(Theme.Colors.primaryDark)
                    .frame(width: 20)

                Text(label)
                    .font(Theme.Typography.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Text(value)
                .font(Theme.Typography.bodyMedium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
    }
}

// MARK: - Schedule Setup Sheet

struct ScheduleSetupSheet: View {
    let plantType: PlantType
    @Bindable var viewModel: PlantLibraryViewModel
    let onComplete: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.xl) {
                // Header
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Set Watering Schedule")
                        .font(Theme.Typography.headlineLarge)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("How often should we remind you?")
                        .font(Theme.Typography.bodyMedium)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                .padding(.top, Theme.Spacing.xl)

                // Schedule picker
                Picker("Watering frequency", selection: $viewModel.customWateringDays) {
                    ForEach(viewModel.wateringOptions, id: \.self) { days in
                        Text(viewModel.wateringLabel(for: days)).tag(days)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)

                // Recommendation
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(Theme.Colors.statusYellow)

                    Text("Recommended: \(plantType.wateringFrequencyText)")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                // Name field
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Give it a name (optional)")
                        .font(Theme.Typography.labelMedium)
                        .foregroundColor(Theme.Colors.textSecondary)

                    TextField("e.g., Gerald, Planty McPlantface", text: $viewModel.customName)
                        .font(Theme.Typography.bodyLarge)
                        .padding(Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                .fill(Theme.Colors.backgroundSecondary)
                        )
                }
                .padding(.horizontal, Theme.Spacing.screenPadding)

                Spacer()

                // Add button
                Button(action: onComplete) {
                    Text("Add to My Plants")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Theme.Spacing.screenPadding)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .background(Theme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        viewModel.showingScheduleSetup = false
                        viewModel.showingPlantInfo = true
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PlantLibraryView(
        viewModel: PlantLibraryViewModel(),
        onAddPlant: { _ in },
        onDismiss: {}
    )
}

import SwiftUI

// MARK: - Dashboard View
// Main plants tab showing grid of user's plants

struct DashboardView: View {
    @Bindable var viewModel: PlantsViewModel
    @Bindable var appViewModel: AppViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background
                    .ignoresSafeArea()

                if viewModel.isEmpty {
                    DashboardEmptyState(onAddPlant: appViewModel.showAddPlant)
                } else {
                    ScrollView {
                        VStack(spacing: Theme.Spacing.lg) {
                            // Notification warning banner
                            if !appViewModel.notificationsEnabled {
                                NotificationBanner(onTap: {
                                    appViewModel.requestNotificationPermission()
                                })
                                .padding(.horizontal, Theme.Spacing.screenPadding)
                            }

                            // Plant limit banner for free users
                            if !UserPreferences.shared.isPremium {
                                PlantLimitBanner(
                                    currentCount: viewModel.plantCount,
                                    maxCount: UserPreferences.shared.maxFreePlants,
                                    onUpgrade: appViewModel.showPaywall
                                )
                                .padding(.horizontal, Theme.Spacing.screenPadding)
                            }

                            // Plants needing attention section
                            if !viewModel.plantsNeedingWater.isEmpty {
                                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                    SectionHeader(
                                        title: "Needs Attention",
                                        count: viewModel.plantsNeedingWater.count
                                    )

                                    PlantGrid(
                                        plants: viewModel.plantsNeedingWater,
                                        onSelectPlant: { viewModel.selectPlant($0) },
                                        onWaterPlant: { viewModel.waterPlant($0) }
                                    )
                                }
                            }

                            // Healthy plants section
                            if !viewModel.healthyPlants.isEmpty {
                                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                    SectionHeader(
                                        title: viewModel.plantsNeedingWater.isEmpty ? "My Plants" : "Doing Well",
                                        count: viewModel.healthyPlants.count
                                    )

                                    PlantGrid(
                                        plants: viewModel.healthyPlants,
                                        onSelectPlant: { viewModel.selectPlant($0) },
                                        onWaterPlant: { viewModel.waterPlant($0) }
                                    )
                                }
                            }
                        }
                        .padding(.vertical, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Sizes.fabSize + Theme.Spacing.huge)
                    }
                }

                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton(action: appViewModel.showAddPlant)
                            .padding(.trailing, Theme.Spacing.screenPadding)
                            .padding(.bottom, Theme.Spacing.lg)
                    }
                }
            }
            .navigationTitle("My Plants")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: appViewModel.showSettings) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingPlantDetail) {
                if let plant = viewModel.selectedPlant {
                    PlantDetailView(
                        plant: plant,
                        onWater: { viewModel.waterPlant(plant) },
                        onDelete: { appViewModel.deletePlant(plant) },
                        onKill: { appViewModel.killPlant(plant, cause: .neglect) },
                        onUpdate: { viewModel.updatePlant($0) },
                        onDismiss: { viewModel.deselectPlant() }
                    )
                }
            }
        }
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var count: Int? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(Theme.Typography.headlineSmall)
                .foregroundColor(Theme.Colors.textPrimary)

            if let count = count {
                Text("(\(count))")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textTertiary)
            }

            Spacer()
        }
        .padding(.horizontal, Theme.Spacing.screenPadding)
    }
}

// MARK: - Preview

#Preview {
    DashboardView(
        viewModel: PlantsViewModel(),
        appViewModel: AppViewModel.shared
    )
}

import SwiftUI

// MARK: - Graveyard View
// Memorial for dead plants

struct GraveyardView: View {
    @Bindable var viewModel: GraveyardViewModel
    @Bindable var appViewModel: AppViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.graveyardBackground
                    .ignoresSafeArea()

                if viewModel.isEmpty {
                    GraveyardEmptyState()
                } else {
                    ScrollView {
                        VStack(spacing: Theme.Spacing.lg) {
                            // Stats banner
                            GraveyardStatsBanner(viewModel: viewModel)
                                .padding(.horizontal, Theme.Spacing.screenPadding)

                            // Resurrection eligible section
                            if !viewModel.resurrectionEligible.isEmpty {
                                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .foregroundColor(Theme.Colors.statusGreen)

                                        Text("Can Be Resurrected")
                                            .font(Theme.Typography.headlineSmall)
                                            .foregroundColor(Theme.Colors.textPrimary)

                                        Text("(\(viewModel.resurrectionEligible.count))")
                                            .font(Theme.Typography.bodyMedium)
                                            .foregroundColor(Theme.Colors.textTertiary)
                                    }
                                    .padding(.horizontal, Theme.Spacing.screenPadding)

                                    TombstoneGrid(
                                        entries: viewModel.resurrectionEligible,
                                        onSelectEntry: { viewModel.selectEntry($0) }
                                    )
                                }
                            }

                            // Permanently dead section
                            if !viewModel.permanentlyDead.isEmpty {
                                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                    HStack {
                                        Image(systemName: "moon.zzz.fill")
                                            .foregroundColor(Theme.Colors.textTertiary)

                                        Text("Resting in Peace")
                                            .font(Theme.Typography.headlineSmall)
                                            .foregroundColor(Theme.Colors.textPrimary)

                                        Text("(\(viewModel.permanentlyDead.count))")
                                            .font(Theme.Typography.bodyMedium)
                                            .foregroundColor(Theme.Colors.textTertiary)
                                    }
                                    .padding(.horizontal, Theme.Spacing.screenPadding)

                                    TombstoneGrid(
                                        entries: viewModel.permanentlyDead,
                                        onSelectEntry: { viewModel.selectEntry($0) }
                                    )
                                }
                            }
                        }
                        .padding(.vertical, Theme.Spacing.lg)
                    }
                }
            }
            .navigationTitle("Graveyard")
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
            .sheet(isPresented: $viewModel.showingEntryDetail) {
                if let entry = viewModel.selectedEntry {
                    GraveyardDetailView(
                        entry: entry,
                        onResurrect: {
                            appViewModel.resurrectPlant(from: entry)
                        },
                        onDismiss: { viewModel.deselectEntry() }
                    )
                }
            }
        }
    }
}

// MARK: - Graveyard Stats Banner

struct GraveyardStatsBanner: View {
    let viewModel: GraveyardViewModel

    var body: some View {
        HStack(spacing: Theme.Spacing.xl) {
            StatBubble(
                value: "\(viewModel.totalDeaths)",
                label: "Total Lost",
                color: Theme.Colors.statusRed
            )

            StatBubble(
                value: "\(viewModel.averageSurvivalDays)",
                label: "Avg Days",
                color: Theme.Colors.statusYellow
            )

            StatBubble(
                value: "\(viewModel.longestSurvival)",
                label: "Best Run",
                color: Theme.Colors.statusGreen
            )
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                .fill(Theme.Colors.cardBackground)
                .themeShadow(Theme.Shadows.card)
        )
    }
}

struct StatBubble: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Theme.Spacing.xxs) {
            Text(value)
                .font(Theme.Typography.displaySmall)
                .foregroundColor(color)

            Text(label)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    GraveyardView(
        viewModel: GraveyardViewModel(),
        appViewModel: AppViewModel.shared
    )
}

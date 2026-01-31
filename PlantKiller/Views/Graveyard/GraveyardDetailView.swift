import SwiftUI

// MARK: - Graveyard Detail View
// Memorial detail card for a dead plant

struct GraveyardDetailView: View {
    let entry: GraveyardEntry
    let onResurrect: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Tombstone
                    TombstoneImageView(plantTypeId: entry.plantTypeId, size: 180)
                        .padding(.top, Theme.Spacing.xl)

                    // Memorial text
                    VStack(spacing: Theme.Spacing.sm) {
                        Text("In Loving Memory of")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textTertiary)
                            .textCase(.uppercase)

                        Text(entry.plantName)
                            .font(Theme.Typography.displayMedium)
                            .foregroundColor(Theme.Colors.textPrimary)

                        if let plantType = entry.plantType {
                            Text(plantType.commonName)
                                .font(Theme.Typography.bodyMedium)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        Text("\"\(entry.causeOfDeath.epitaph)\"")
                            .font(Theme.Typography.bodyMedium)
                            .foregroundColor(Theme.Colors.textTertiary)
                            .italic()
                            .padding(.top, Theme.Spacing.xs)
                    }

                    // Survival stats
                    VStack(spacing: Theme.Spacing.md) {
                        HStack {
                            Text("Memorial")
                                .font(Theme.Typography.labelLarge)
                                .foregroundColor(Theme.Colors.textSecondary)
                            Spacer()
                        }

                        Divider()

                        MemorialRow(label: "Date of Death", value: entry.deathDateText)
                        MemorialRow(label: "Survival Time", value: entry.survivalText)
                        MemorialRow(label: "Cause of Death", value: entry.causeOfDeath.rawValue)

                        if entry.canResurrect {
                            Divider()

                            ResurrectionBanner(daysRemaining: entry.daysUntilPermanentDeath)
                        }
                    }
                    .padding(Theme.Spacing.cardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                            .fill(Theme.Colors.cardBackground)
                            .themeShadow(Theme.Shadows.card)
                    )
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Snarky message
                    Text(entry.causeOfDeath.snarkyMessage)
                        .font(Theme.Typography.bodyMedium)
                        .foregroundColor(Theme.Colors.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.xl)

                    // Resurrection button
                    if entry.canResurrect {
                        VStack(spacing: Theme.Spacing.sm) {
                            Button(action: onResurrect) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Resurrect Plant")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Text("Give \(entry.plantName) another chance at life")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textTertiary)
                        }
                        .padding(.horizontal, Theme.Spacing.screenPadding)
                    } else {
                        VStack(spacing: Theme.Spacing.sm) {
                            Text("Resurrection Period Expired")
                                .font(Theme.Typography.labelLarge)
                                .foregroundColor(Theme.Colors.statusRed)

                            Text("\(entry.plantName) has moved on to plant heaven")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textTertiary)
                        }
                    }

                    Spacer(minLength: Theme.Spacing.xl)
                }
            }
            .background(Theme.Colors.graveyardBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Memorial Row

struct MemorialRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(Theme.Typography.bodyMedium)
                .foregroundColor(Theme.Colors.textSecondary)

            Spacer()

            Text(value)
                .font(Theme.Typography.bodyMedium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
    }
}

// MARK: - Preview

#Preview {
    GraveyardDetailView(
        entry: GraveyardEntry.sampleEntries[0],
        onResurrect: {},
        onDismiss: {}
    )
}

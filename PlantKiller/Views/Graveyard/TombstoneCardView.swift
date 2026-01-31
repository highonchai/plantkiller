import SwiftUI

// MARK: - Tombstone Card View
// Grid card showing a dead plant as a tombstone

struct TombstoneCardView: View {
    let entry: GraveyardEntry
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Theme.Spacing.sm) {
                // Tombstone image
                ZStack {
                    TombstoneImageView(plantTypeId: entry.plantTypeId, size: Theme.Sizes.tombstoneWidth)

                    // Resurrection indicator
                    if entry.canResurrect {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Theme.Colors.statusGreen)
                                    .background(
                                        Circle()
                                            .fill(Theme.Colors.cardBackground)
                                            .frame(width: 24, height: 24)
                                    )
                            }
                        }
                        .frame(width: Theme.Sizes.tombstoneWidth * 0.7, height: Theme.Sizes.tombstoneWidth * 0.9)
                    }
                }

                // Plant name
                VStack(spacing: Theme.Spacing.xxs) {
                    Text(entry.plantName)
                        .font(Theme.Typography.plantName)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(1)

                    Text(entry.causeOfDeath.epitaph)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textTertiary)
                        .lineLimit(1)
                        .italic()
                }
            }
            .padding(Theme.Spacing.md)
            .frame(width: Theme.Sizes.tombstoneWidth + Theme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.cardBackground)
                    .themeShadow(Theme.Shadows.card)
            )
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Tombstone Grid

struct TombstoneGrid: View {
    let entries: [GraveyardEntry]
    let onSelectEntry: (GraveyardEntry) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: Theme.Sizes.tombstoneWidth + Theme.Spacing.md), spacing: Theme.Spacing.gridSpacing)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.gridSpacing) {
            ForEach(entries) { entry in
                TombstoneCardView(
                    entry: entry,
                    onTap: { onSelectEntry(entry) }
                )
            }
        }
        .padding(.horizontal, Theme.Spacing.screenPadding)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Theme.Spacing.xl) {
            TombstoneGrid(
                entries: GraveyardEntry.sampleEntries,
                onSelectEntry: { entry in
                    print("Selected: \(entry.plantName)")
                }
            )
        }
        .padding(.vertical, Theme.Spacing.lg)
    }
    .background(Theme.Colors.graveyardBackground)
}

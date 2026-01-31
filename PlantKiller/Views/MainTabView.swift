import SwiftUI

// MARK: - Main Tab View
// Bottom tab navigation for the app

struct MainTabView: View {
    @Bindable var appViewModel: AppViewModel

    var body: some View {
        TabView(selection: Binding(
            get: { appViewModel.selectedTab },
            set: { appViewModel.selectedTab = $0 }
        )) {
            // Plants Tab
            DashboardView(
                viewModel: appViewModel.plantsViewModel,
                appViewModel: appViewModel
            )
            .tabItem {
                Label("Plants", systemImage: "leaf.fill")
            }
            .tag(AppViewModel.Tab.plants)

            // Graveyard Tab
            GraveyardView(
                viewModel: appViewModel.graveyardViewModel,
                appViewModel: appViewModel
            )
            .tabItem {
                Label("Graveyard", systemImage: "cross.fill")
            }
            .tag(AppViewModel.Tab.graveyard)
        }
        .tint(Theme.Colors.primaryDark)
        .sheet(isPresented: $appViewModel.showingAddPlant) {
            PlantLibraryView(
                viewModel: appViewModel.plantLibraryViewModel,
                onAddPlant: { plant in appViewModel.addPlant(plant) },
                onDismiss: { appViewModel.hideAddPlant() }
            )
        }
        .sheet(isPresented: $appViewModel.showingSettings) {
            SettingsView(
                appViewModel: appViewModel,
                onDismiss: { appViewModel.hideSettings() }
            )
        }
        .sheet(isPresented: $appViewModel.showingPaywall) {
            PaywallView(
                onPurchase: { appViewModel.upgradeToPremium() },
                onRestore: { appViewModel.restorePurchases() },
                onDismiss: { appViewModel.hidePaywall() }
            )
        }
        .alert(appViewModel.alertTitle, isPresented: $appViewModel.showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(appViewModel.alertMessage)
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView(appViewModel: AppViewModel.shared)
}

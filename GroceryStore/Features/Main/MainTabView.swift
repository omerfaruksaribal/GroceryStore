import SwiftUI

struct MainTabView: View {
    @StateObject private var cartStore = CartStore.shared

    var body: some View {
        TabView {
            // ---------- SHOP ----------
            ProductGridView()
                .tabItem {
                    Label("Shop", systemImage: "cart")
                }

            // ---------- CART ----------
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                        .badge(cartStore.items.count)
                }
        }
        // Light haptic – rota değiştiğinde sepeti senkronize etmeye gerek kalmaz;
        // LaunchView içinde zaten `syncFromBackend()` çağrısı yapıyoruz.
    }
}

import SwiftUI

enum AppTab: Hashable { case shop, cart, whislist, profile }

struct MainTabView: View {
    @State private var selection: AppTab = .shop

    var body: some View {
        TabView(selection: $selection) {
            ProductGridView()
                .tabItem { Label("Shop", systemImage: "cart") }
                .tag(AppTab.shop)

            CartView()
                .tabItem { Label("Cart", systemImage: "cart.fill.badge.plus") }
                .tag(AppTab.cart)

            WishlistView()
                .tabItem { Label("Wishlist", systemImage: "heart") }
                .tag(AppTab.whislist)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(AppTab.profile)
        }
    }
}

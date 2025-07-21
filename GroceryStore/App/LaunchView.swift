import SwiftUI

struct LaunchView: View {
    @State private var route: AppRoute = .auth
    @State private var isRefreshing = true

    var body: some View {
        ZStack {
            switch route {
            case .auth:
                NavigationStack { LoginView() }
            case .main:
                MainTabView()  
            }

            if isRefreshing {
                ProgressView().scaleEffect(1.4)
            }
        }
        .task {
            if await AuthService().refreshIfNeeded() {
                await CartStore.shared.syncFromBackend() // Cart
                route = .main
            } else {
                route = .auth
            }
            isRefreshing = false
            //print("🔑 accessToken ->", AuthStore.shared.accessToken ?? "nil")

        }
        .onChange(of: AuthStore.shared.accessToken) { _, newToken in
            if newToken != nil {
                route = .main
                // View geçişini bir sonraki run-loop’a ertele
                DispatchQueue.main.async {
                    Task { await CartStore.shared.syncFromBackend() }
                }
            } else {
                route = .auth
            }
        }

        .animation(.easeInOut, value: route)
    }
}

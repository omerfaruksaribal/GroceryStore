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
                ProductGridView()
            }

            if isRefreshing {
                ProgressView().scaleEffect(1.4)
            }
        }
        .task {
            if await AuthService().refreshIfNeeded() {
                route = .main
            } else {
                route = .auth
            }
            isRefreshing = false
            //print("🔑 accessToken ->", AuthStore.shared.accessToken ?? "nil")

        }
        .animation(.easeInOut, value: route)
    }
}

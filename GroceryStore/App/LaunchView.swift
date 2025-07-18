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
                // Placeholder
                Text("Main Screen")
            }

            if isRefreshing {
                ProgressView().scaleEffect(1.4)
            }
        }
        .task {
            print("BASE_URL ->", Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as Any)
            if await AuthService().refreshIfNeeded() {
                route = .main
            } else {
                route = .auth
            }
            isRefreshing = false
        }
        .animation(.easeInOut, value: route)
    }
}

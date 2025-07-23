import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileVM()
    @State private var showEditSheet = false

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") { showEditSheet = true }
                    }
                }
                // --------------  NAVIGATION DESTINATION  -------------
                .navigationDestination(for: OrderResponse.self) { order in
                    OrderDetailView(order: order)
                }
        }
        .task { await vm.load() }
        .onAppear {
            if vm.profile == nil && !vm.isLoading {
                Task { await vm.load() }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditProfileSheet { u, p in
                await vm.update(username: u, password: p)
            }
        }
    }

    // MARK: - Profile page
    @ViewBuilder private var content: some View {
        if vm.isLoading {
            ProgressView()
        } else if let err = vm.error {
            Text("Error: \(err)").foregroundStyle(.red)
        } else if let profile = vm.profile {
            List {
                // ------- Account -------
                Section("Account") {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(profile.username)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(profile.email)
                    }
                }

                // ------- Recent Orders -------
                if let recent = profile.orders, !recent.isEmpty {
                    Section("Recent Orders") {
                        ForEach(recent.prefix(3)) { order in
                            NavigationLink(value: order) {
                                HStack {
                                    Text(order.orderId)
                                    Spacer()
                                    Text("$ \(order.total, specifier: "%.2f")")
                                }
                            }
                        }
                        if recent.count > 3 {
                            NavigationLink("All Orders") { OrdersView() }
                        }
                    }
                }
                
                // ------- Logout -------
                Section {
                    Button("Logout") { vm.logout() }
                        .foregroundStyle(.red)
                }
        }
        } else {
            Text("No profile data").foregroundStyle(.secondary)
        }
    }
}

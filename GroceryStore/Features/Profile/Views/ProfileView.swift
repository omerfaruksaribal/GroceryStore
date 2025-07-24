import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileVM()
    @State private var showEditSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                content
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
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
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(1.3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        } else if let err = vm.error {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text("Error: \(err)")
                    .foregroundStyle(.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        } else if let profile = vm.profile {
            VStack(spacing: 24) {
                // ------- Account -------
                VStack(spacing: 0) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(profile.username)
                    }
                    Divider()
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(profile.email)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                )

                // ------- Recent Orders -------
                if let recent = profile.orders, !recent.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Orders")
                            .font(.headline)
                        ForEach(recent.prefix(3)) { order in
                            NavigationLink(value: order) {
                                HStack {
                                    Text(order.orderId)
                                    Spacer()
                                    Text("$ \(order.total, specifier: "%.2f")")
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(.tertiarySystemGroupedBackground))
                                )
                            }
                        }
                        if recent.count > 3 {
                            NavigationLink("All Orders") { OrdersView() }
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    )
                }

                // ------- Logout -------
                Button {
                    vm.logout()
                } label: {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
            }
            .padding()
        } else {
            Text("No profile data").foregroundStyle(.secondary)
        }
    }
}

import SwiftUI

struct OrdersView: View {
    @StateObject private var vm = OrdersVM()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
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
                } else if vm.orders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "shippingbox")
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(.secondary)
                        Text("No orders yet.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                } else {
                    List {
                        ForEach(vm.orders) { order in
                            NavigationLink(value: order) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(order.orderId)
                                            .font(.headline)
                                        Text(order.date)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("$ \(order.total, specifier: "%.2f")")
                                        .font(.headline)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(.secondarySystemGroupedBackground))
                                        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: OrderResponse.self) { order in
                OrderDetailView(order: order)
            }
            .task { await  vm.load() }
        }
    }
}

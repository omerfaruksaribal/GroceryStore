import SwiftUI

struct CartView: View {
    @StateObject private var store = CartStore.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                if store.items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(.secondary)
                        Text("Your cart is empty")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                } else {
                    List {
                        ForEach(store.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.productName)
                                        .font(.headline)
                                    Stepper(value: binding(for: item), in: 1...99) {
                                        Text("Quantity: \(item.quantity)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                Text("$ \(item.lineTotal, specifier: "%.2f")")
                                    .font(.headline)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.secondarySystemGroupedBackground))
                                    .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                            )
                        }
                        .onDelete { index in
                            for i in index {
                                Task { await store.remove(item: store.items[i]) }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .safeAreaInset(edge: .bottom) {
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text("$ \(store.total, specifier: "%.2f")").bold()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await store.clear() }
                    } label: {
                        Label("Clear", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                    }
                    .disabled(store.items.isEmpty)
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        CheckoutView()
                    } label: {
                        Label("Checkout", systemImage: "creditcard")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.items.isEmpty)
                }
            }
            .task { await store.syncFromBackend() }
        }
    }

    // two-way binding for Stepper
    private func binding(for item: CartItem) -> Binding<Int> {
        Binding {
            item.quantity
        } set: { newQty in
            Task { await store.update(item: item, qty: newQty) }
        }
    }
}

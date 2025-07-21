import SwiftUI

struct CartView: View {
    @StateObject private var store = CartStore.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.productName)
                                .bold()
                            Stepper(value: binding(for: item), in: 1...99) {
                                Text("Quantity: \(item.quantity)")
                            }
                        }
                        Spacer()
                        Text("$ \(item.lineTotal, specifier: "%.2f")")
                    }
                }
                .onDelete { index in
                    for i in index {
                        Task { await store.remove(item: store.items[i]) }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Text("Total:")
                    Spacer()
                    Text("$ \(store.total, specifier: "%.2f")").bold()
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        Task {
                            await store.clear()
                        }
                    }
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

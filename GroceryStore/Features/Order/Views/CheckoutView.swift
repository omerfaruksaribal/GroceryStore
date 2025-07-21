import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = CartStore.shared

    @State private var address = ""
    @State private var isPlacing = false
    @State private var result: OrderResponse?
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Delivery Address") {
                    TextField("Type your address...", text: $address)
                }

                Section("Items") {
                    ForEach(store.items) { item in
                        HStack {
                            Text("\(item.productName) x\(item.quantity)")
                            Spacer()
                            Text("$ \(item.lineTotal, specifier: "%.2f")")
                        }
                    }
                }

                Section("Total") {
                    Text("$ \(store.total, specifier: "%.2f")")
                        .bold()
                }
            }

            Button {
                placeOrder()
            } label: {
                Text("Place Order")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(isPlacing || address.trimmingCharacters(in: .whitespaces).isEmpty)
            .overlay {
                if isPlacing { ProgressView() }
            }
            .navigationTitle("Checkout")
            .sheet(item: $result) { order in
                OrderSuccessView(order: order) { dismiss() }
            }
            .alert("Order Failed", isPresented: .constant(error != nil), actions: {
                Button("OK") { error = nil }
            }, message: { Text(error ?? "") })
        }
    }

    private func placeOrder() {
        Task {
            isPlacing = true
            if let order = await store.checkOut(address: address) {
                result = order
            } else {
                error = "Could not place the order. Please try again later."
            }
            isPlacing = false
        }
    }
}

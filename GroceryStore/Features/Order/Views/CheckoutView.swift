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
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 24) {
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
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, 4)

                    Button {
                        placeOrder()
                    } label: {
                        Label("Place Order", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title3)
                    .padding(.horizontal)
                    .disabled(isPlacing || address.trimmingCharacters(in: .whitespaces).isEmpty)
                    .overlay {
                        if isPlacing { ProgressView() }
                    }
                }
                .padding(.top, 12)
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.large)
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

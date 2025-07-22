import SwiftUI

struct OrdersView: View {
    @StateObject private var vm = OrdersVM()

    var body: some View {
        List {
            if vm.isLoading {
                ProgressView()
            } else if let err = vm.error {
                Text("Error: \(err)").foregroundStyle(.red)
            } else if vm.orders.isEmpty {
                Text("No orders yet.").foregroundStyle(.secondary)
            } else {
                ForEach(vm.orders) { order in
                    NavigationLink(value: order) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(order.orderId)
                                Text(order.date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$ \(order.totalAmount, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .navigationTitle("Orders")
        .navigationDestination(for: OrderResponse.self) { order in
            OrderDetailView(order: order)
        }
        .task { await  vm.load() }
    }
}

import SwiftUI

struct OrderSuccessView: View {
    let order: OrderResponse
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("🎉 Order Placed!")
                .font(.largeTitle).bold()

            Text("Order ID: \(order.orderId)")
            Text("Deliver to: \(order.address)")
            Text("Total: $ \(order.totalAmount, specifier: "%.2f")")

            Button("Done") { onClose() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

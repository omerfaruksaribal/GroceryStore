import SwiftUI

struct OrderSuccessView: View {
    let order: OrderResponse
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding(.top, 16)
            Text("Order Placed!")
                .font(.largeTitle).bold()
            VStack(spacing: 8) {
                Text("Order ID: \(order.orderId)")
                Text("Deliver to: \(order.address)")
                Text("Total: $ \(order.total, specifier: "%.2f")")
            }
            .font(.title3)
            Button("Done") { onClose() }
                .buttonStyle(.borderedProminent)
                .padding(.top, 12)
        }
        .padding()
        .frame(maxWidth: 400)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

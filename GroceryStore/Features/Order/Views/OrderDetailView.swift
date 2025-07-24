// Features/Orders/Views/OrderDetailView.swift
import SwiftUI

struct OrderDetailView: View {
    let order: OrderResponse

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                infoSection
                itemsSection
                totalSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.large)
    }

    private var infoSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Order ID")
                Spacer()
                Text(order.orderId)
            }
            Divider()
            HStack {
                Text("Date")
                Spacer()
                Text(order.date)
            }
            Divider()
            HStack {
                Text("Address")
                Spacer()
                Text(order.address)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items")
                .font(.headline)
            ForEach(order.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.productName)
                        Text("x\(item.quantity)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("$ \(Double(item.quantity) * item.price, specifier: "%.2f")")
                }
                Divider()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }

    private var totalSection: some View {
        HStack {
            Text("Total").bold()
            Spacer()
            Text("$ \(order.total, specifier: "%.2f")").bold()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}

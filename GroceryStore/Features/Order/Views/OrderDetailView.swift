// Features/Orders/Views/OrderDetailView.swift
import SwiftUI

struct OrderDetailView: View {
    let order: OrderResponse

    var body: some View {
        List {
            Section("Info") {
                HStack {
                    Text("Order ID")
                    Spacer()
                    Text(order.orderId)
                }

                HStack {
                    Text("Date")
                    Spacer()
                    Text(order.date)
                }

                HStack {
                    Text("Address")
                    Spacer()
                    Text(order.address)
                }
            }
            Section("Items") {
                ForEach(order.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.productName)
                            Text("x\(item.quantity)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("$ \(Double(item.quantity) * item.price, specifier: "%.2f")")
                    }
                }
            }
            Section {
                HStack {
                    Text("Total").bold()
                    Spacer()
                    Text("$ \(order.total, specifier: "%.2f")").bold()
                }
            }
        }
        .navigationTitle("Order Details")
    }
}

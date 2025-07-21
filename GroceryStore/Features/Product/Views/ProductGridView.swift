import SwiftUI

struct ProductGridView: View {
    @StateObject private var vm = ProductGridVM()
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.products.isEmpty && vm.isLoadingPage {
                    ProgressView().padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(vm.products, id: \.id) { product in
                            NavigationLink(value: product) {
                                ProductCard(product: product)
                            }
                            .onAppear {
                                if product.id == vm.products.last?.id {
                                    Task { await vm.loadNextPage() }
                                }
                            }
                        }
                        if vm.isLoadingPage {
                            ProgressView().padding()
                        }
                        
                        Text("Count = \(vm.products.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                    }
                    .padding()
                }
            }
            .navigationTitle("Products")
            .refreshable { await vm.refresh() }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(productId: product.id)
            }
            .task { await vm.refresh() }
            .overlay {
                if let err = vm.errorMessage {
                    Text(err).foregroundColor(.red).padding()
                }
            }
        }
        .onAppear {                         
            if vm.products.isEmpty {
                Task { await vm.refresh() }
            }
        }
    }
}

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: product.imageUrl) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.1)
                        .overlay { ProgressView() }
                case .success(let img):
                    img.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 120)
            .clipped()

            Text(product.name)
                .font(.headline)
                .lineLimit(1)

            Text(String(format: "$ %.2f", product.price))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .background(.background)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

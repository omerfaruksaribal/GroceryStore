import SwiftUI

struct ProductGridView: View {
    @StateObject private var vm = ProductGridVM()
    @ObservedObject private var wishlist = WishlistStore.shared

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    if vm.products.isEmpty && vm.isLoadingPage {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(vm.products, id: \.id) { product in
                                NavigationLink(value: product) {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    if product.id == vm.products.last?.id {
                                        Task { await vm.loadNextPage() }
                                    }
                                }
                            }
                            if vm.isLoadingPage {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }
                }
                .navigationTitle("Products")
                .navigationBarTitleDisplayMode(.large)
                .refreshable { await vm.refresh() }
                .navigationDestination(for: Product.self) { product in
                    ProductDetailView(productId: product.id)
                }
                .task { await vm.refresh() }
                .overlay {
                    if let err = vm.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            Text(err)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                    }
                }
                // Wishlist
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !wishlist.items.isEmpty {
                            NavigationLink {
                                WishlistView()
                            } label: {
                                Label("\(wishlist.items.count)", systemImage: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                            .accessibilityLabel("Wishlist, \(wishlist.items.count) items")
                        }
                    }
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
    @ObservedObject private var wishlist = WishlistStore.shared

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: product.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                        }
                    case .success(let img):
                        img.resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
                )

                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(String(format: "$ %.2f", product.price))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            // Wishlist overlay
            let isFav = wishlist.items.contains { $0.id == product.id }
            Button {
                Task { await wishlist.toggle(product: product) }
            } label: {
                Image(systemName: isFav ? "heart.fill" : "heart")
                    .font(.title2)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .foregroundStyle(isFav ? .red : .secondary)
                    .shadow(radius: isFav ? 4 : 0)
            }
            .buttonStyle(.plain)
            .padding(6)
        }
    }
}

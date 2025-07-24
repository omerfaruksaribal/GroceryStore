import SwiftUI

struct WishlistView: View {

    @ObservedObject private var store = WishlistStore.shared

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Wishlist")
                .toolbar {
                    if !store.items.isEmpty {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Clear") {
                                Task { await store.clear() }
                            }
                        }
                    }
                }
                .task { await store.sync() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            ProgressView()
        } else if let err = store.error {
            Text("Error: \(err)")
                .foregroundStyle(.red)
        } else if store.items.isEmpty {
            ContentUnavailableView("Your wishlist is empty",
                                   systemImage: "heart")
        } else {
            listSection
        }
    }

    private var listSection: some View {
        List {
            ForEach(store.items) { item in
                NavigationLink {
                    ProductDetailView(productId: item.id)
                } label: {
                    HStack {
                        AsyncImage(url: item.imageUrl) { phase in
                            switch phase {
                            case .empty: Color.gray.opacity(0.1)
                            case .success(let img): img.resizable()
                            case .failure: Image(systemName: "photo")
                            @unknown default: EmptyView()
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                        VStack(alignment: .leading) {
                            Text(item.name).lineLimit(1)
                            Text("$ \(item.price, specifier: "%.2f")")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        Task { await store.remove(productId: item.id) }
                    } label: {
                        Label("Remove", systemImage: "heart.slash")
                    }
                }
            }
        }
    }
}

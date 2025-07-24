import SwiftUI

struct WishlistView: View {
    @ObservedObject private var store = WishlistStore.shared

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Wishlist")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    if !store.items.isEmpty {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                Task { await store.clear() }
                            } label: {
                                Label("Clear", systemImage: "trash")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .task { await store.sync() }
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .scaleEffect(1.5)
        } else if let err = store.error {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text("Error: \(err)")
                    .foregroundStyle(.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        } else if store.items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "heart")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(.pink)
                Text("Your wishlist is empty")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        } else {
            listSection
        }
    }

    private var listSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.items) { item in
                    NavigationLink(destination: ProductDetailView(productId: item.id)) {
                        HStack(spacing: 16) {
                            AsyncImage(url: item.imageUrl) { phase in
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
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
                            )

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                Text("$ \(item.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.secondarySystemGroupedBackground))
                                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await store.remove(productId: item.id) }
                        } label: {
                            Label("Remove", systemImage: "heart.slash")
                        }
                        .tint(.pink)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
    }
}

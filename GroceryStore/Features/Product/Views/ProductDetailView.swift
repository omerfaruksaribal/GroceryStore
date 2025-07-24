import SwiftUI

struct ProductDetailView: View {
    let productId: String
    @State private var vm = ProductDetailVM()
    @State private var showAddReview = false

    var body: some View {
        Group {
            if vm.isLoading {
                VStack {
                    ProgressView("Loading…")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
            } else if let error = vm.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
            } else if let p = vm.product {
                ProductContent(
                    product: p,
                    reviews: vm.reviews,
                    onDelete: { await vm.deleteMyReview(productId: productId) }
                )
            } else {
                Text("No Data")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddReview = true
                } label: {
                    Label("Add Review", systemImage: "plus.bubble")
                }
                .disabled(AuthStore.shared.accessToken == nil)
            }
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewSheet { rating, comment in
                await vm.addReview(
                    rating: rating,
                    comment: comment,
                    productId: productId
                )
            }
        }
        .task { await vm.load(id: productId) }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

private struct ProductContent: View {
    let product: Product
    let reviews: [ReviewDTO]
    let onDelete: () async -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                productImage
                productInfo
                if !reviews.isEmpty { reviewSection }
            }
            .padding(.bottom, 24)
        }
    }

    private var productImage: some View {
        AsyncImage(url: product.imageUrl) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
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
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(product.name)
                .font(.title)
                .bold()
            Text(String(format: "$ %.2f", product.price))
                .font(.title2)
                .foregroundStyle(.green)
            Text("Brand: \(product.brand)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(product.description)
                .font(.body)
            Button {
                Task { await CartStore.shared.add(product: product) }
            } label: {
                Label("Add to Cart", systemImage: "cart.badge.plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text("Reviews")
                .font(.headline)
            ForEach(reviews) { rev in
                ReviewRow(review: rev)
                    .swipeActions {
                        if rev.username == AuthStore.shared.currentUsername {
                            Button(role: .destructive) {
                                Task { await onDelete() }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct ReviewRow: View {
    let review: ReviewDTO
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.username).bold()
                Spacer()
                Text("★ \(review.rating)")
                    .foregroundStyle(.orange)
            }
            Text(review.comment)
            Text(review.date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
        Divider()
    }
}

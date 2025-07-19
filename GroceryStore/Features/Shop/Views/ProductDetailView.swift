import SwiftUI

struct ProductDetailView: View {
    let productId: String
    @State private var vm = ProductDetailVM()          // StateObject ⇒ tek instance

    var body: some View {
        Group {
            if vm.isLoading        { LoadingView() }
            else if let error = vm.errorMessage {
                ErrorView(message: error)
            }
            else if let p = vm.product {
                ProductContent(product: p,
                               loadMore: { await vm.load(id: productId) })
            } else {
                Text("No Data").foregroundStyle(.secondary).padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load(id: productId) }
    }
}

private struct LoadingView: View {
    var body: some View {
        ProgressView("Loading…").padding()
    }
}

private struct ErrorView: View {
    let message: String
    var body: some View {
        Text(message).foregroundStyle(.red).padding()
    }
}

private struct ProductContent: View {
    let product: Product
    let loadMore: () async -> Void          // ileride yorum ekleme vs. için

    var body: some View {
        ScrollView {
            productImage
            productInfo
            if !product.reviews.isEmpty { reviewSection }
        }
    }

    // MARK: – Sub-views

    private var productImage: some View {
        AsyncImage(url: product.imageUrl) { phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.1).overlay { ProgressView() }
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
        .clipped()
    }

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(product.name).font(.title).bold()
            Text(String(format: "$ %.2f", product.price))
                .font(.title2).foregroundStyle(.green)
            Text("Brand: \(product.brand)")
                .font(.subheadline).foregroundStyle(.secondary)
            Text(product.description).font(.body)
        }
        .padding()
    }

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text("Reviews").font(.headline)
            ForEach(product.reviews) { review in
                ReviewRow(review: review)
            }
        }
        .padding(.horizontal)
    }
}

private struct ReviewRow: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.username).bold()
                Spacer()
                Text("★ \(review.rating)").foregroundStyle(.orange)
            }
            Text(review.comment)
            Text(review.date)
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
        Divider()
    }
}

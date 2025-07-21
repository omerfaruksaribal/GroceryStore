struct ProductService {
    private let api = APIClient.shared

    func fetchPage(offset: Int = 0, limit: Int = 10) async throws -> ProductListPage {
        let ep = ProductEndpoint.list(offset: offset, limit: limit)
    //    print("🌐 will call ->", ep.url.absoluteString)          // 🟢 URL kontrol
        typealias Wrapped = ApiResponse<ProductListPage>
        let wrapped: Wrapped = try await api.send(ep)
  //      print("⬅️ status", wrapped.status)                      // 🟢 HTTP kodu

        guard let page = wrapped.data else { throw APIError.status(wrapped.status) }
//        print("📦 fetched", page.products.count)                // 🟢 Ürün sayısı
        return page
    }

    func fetchDetail(id: String) async throws -> Product {
        typealias Wrapped = ApiResponse<Product>
        let wrapped: Wrapped = try await api.send(ProductEndpoint.detail(id: id))

        guard let product = wrapped.data else { throw APIError.status(wrapped.status) }
        return product
    }
}

struct ProductListPage: Codable {
    let products: [Product]
    let totalProducts: Int
    let totalPages: Int
    let currentPage: Int
}

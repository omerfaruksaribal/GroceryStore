import OSLog

enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.grocerystore"

    static let network = Logger(subsystem: subsystem, category: "network")
    static let decoding = Logger(subsystem: subsystem, category: "decoding")
}

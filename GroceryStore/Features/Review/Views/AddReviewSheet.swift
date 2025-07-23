import SwiftUI

struct AddReviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating = 3
    @State private var comment = ""

    var onSave: (_ rating: Int, _ comment: String) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                TextField("Comment", text: $comment, axis: .vertical)
            }
            .navigationTitle("Add Review")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await onSave(rating, comment)
                            dismiss()
                        }
                    }
                    .disabled(comment.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

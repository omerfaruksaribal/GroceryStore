import SwiftUI

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var isSaving = false
    let onSave: (String, String) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("New Info") {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            isSaving = true
                            await onSave(username, password)
                            isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty || isSaving)
                }
            }
        }
    }
}

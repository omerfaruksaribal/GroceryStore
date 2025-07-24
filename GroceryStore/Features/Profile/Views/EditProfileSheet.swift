import SwiftUI

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var isSaving = false
    let onSave: (String, String) async -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 24) {
                    Form {
                        Section("New Info") {
                            TextField("Username", text: $username)
                            SecureField("Password", text: $password)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, 4)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            isSaving = true
                            await onSave(username, password)
                            isSaving = false
                            dismiss()
                        }
                    } label: {
                        Label("Save", systemImage: "checkmark")
                    }
                    .disabled(username.isEmpty || password.isEmpty || isSaving)
                }
            }
        }
    }
}

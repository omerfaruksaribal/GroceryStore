import SwiftUI

struct RegisterView: View {
    @State private var vm = RegisterVM()
    @State private var moveToActivate = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    TextField("Username (min 3)", text: $vm.username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Email", text: $vm.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Password (min 8)", text: $vm.password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                if let msg = vm.successMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text(msg)
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal)
                } else if let err = vm.error {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(err)
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                }
                Button {
                    Task { await vm.submit() }
                } label: {
                    Label("Register", systemImage: "person.crop.circle.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                .padding(.horizontal)
                .disabled(vm.isLoading)
                NavigationLink("Already have an account? Login", destination: LoginView())
                    .font(.footnote)
                    .foregroundColor(.accentColor)
                    .disabled(vm.isLoading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .padding()
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $moveToActivate) {
            ActivateAccountView(email: vm.email)
        }
        .onChange(of: vm.successMessage) { _, newVal in
            if newVal != nil { moveToActivate = true }
        }
    }
}

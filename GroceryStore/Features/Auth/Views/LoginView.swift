import SwiftUI

struct LoginView: View {
    @State private var vm = LoginVM()
    @Environment(\.dismiss) private var dismiss
    @State private var moveToMain = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    TextField("Username", text: $vm.username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $vm.password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                if let err = vm.error {
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
                    Label("Login", systemImage: "arrow.right.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                .padding(.horizontal)
                .disabled(vm.isLoading)
                NavigationLink("Don’t have an account? Register", destination: RegisterView())
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
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: AuthStore.shared.accessToken) { _, newToken in
            moveToMain = newToken != nil
            if newToken != nil {
                Task { await CartStore.shared.syncFromBackend() }
                Task { await WishlistStore.shared.sync() }
            }
        }
        .navigationDestination(isPresented: $moveToMain) {
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

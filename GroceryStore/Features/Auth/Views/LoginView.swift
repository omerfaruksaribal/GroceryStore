import SwiftUI

struct LoginView: View {
    @State private var vm = LoginVM()
    @Environment(\.dismiss) private var dismiss
    @State private var moveToMain = false

    var body: some View {
        VStack(spacing: 24) {
            TextField("Username", text: $vm.username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let err = vm.error {
                Text(err).foregroundStyle(.red)
            }

            Button("Login") {
                Task { await vm.submit() }
            }
            .disabled(vm.isLoading)
            .buttonStyle(.borderedProminent)

            NavigationLink("Don’t have an account? Register", destination: RegisterView())
                .font(.footnote)
        }
        .padding()
        .navigationTitle(Text("Login"))
        .onChange(of: AuthStore.shared.accessToken) { _, newValue in
            if newValue != nil {
                moveToMain = true
            }
        }
        .navigationDestination(isPresented: $moveToMain) {
            Text("Main Screen")
        }
    }
}

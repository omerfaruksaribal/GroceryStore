import SwiftUI

struct LoginView: View {
    @State private var vm = LoginVM()

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
    }
}

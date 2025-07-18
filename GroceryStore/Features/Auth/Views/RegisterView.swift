import SwiftUI

struct RegisterView: View {
    @State private var vm = RegisterVM()
    @State private var moveToActivate = false

    var body: some View {
        VStack(spacing: 24) {
            TextField("Username (min 3)", text: $vm.username)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $vm.email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password (min 8)", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let msg = vm.successMessage {
                Text(msg).foregroundStyle(.green)
            } else if let err = vm.error {
                Text(err).foregroundStyle(.red)
            }

            Button("Register") {
                Task { await vm.submit() }
            }
            .disabled(vm.isLoading)
            .buttonStyle(.borderedProminent)

            NavigationLink("Already have an account? Login", destination: LoginView())
                .font(.footnote)
        }
        .padding()
        .navigationTitle("Register")
        .navigationDestination(isPresented: $moveToActivate) {
            ActivateAccountView(email: vm.email)
        }
        .onChange(of: vm.successMessage) { _, newVal in
            if newVal != nil { moveToActivate = true }

        }
    }
}

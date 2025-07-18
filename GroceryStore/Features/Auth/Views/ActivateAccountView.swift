import SwiftUI

struct ActivateAccountView: View {
    @State private var vm: ActivateAccountVM
    @State private var goToLogin = false

    init(email: String) { _vm = State(initialValue: ActivateAccountVM(email: email)) }

    var body: some View {
        VStack(spacing: 24) {

            // Bilgilendirici e-posta etiketi
            Text("Activation email: \(vm.email)")
                .font(.callout)
                .foregroundColor(.secondary)

            TextField("Activation Code", text: $vm.code)
                .textFieldStyle(.roundedBorder)

            if let ok = vm.successMessage {
                Text(ok).foregroundStyle(.green)
            } else if let err = vm.error {
                Text(err).foregroundStyle(.red)
            }

            Button("Activate") {
                Task { await vm.submit() }
            }
            .disabled(vm.isLoading || vm.code.isEmpty)
            .buttonStyle(.borderedProminent)

            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
        }
        .padding()
        .navigationTitle("Activate")
        .onChange(of: vm.successMessage) { _, newVal in
            if newVal != nil { goToLogin = true }
        }
    }
}

import SwiftUI

struct ActivateAccountView: View {
    @State private var vm: ActivateAccountVM
    @State private var goToLogin = false

    init(email: String) { _vm = State(initialValue: ActivateAccountVM(email: email)) }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text("Activation email: \(vm.email)")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    TextField("Activation Code", text: $vm.code)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal)
                if let ok = vm.successMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text(ok)
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
                    Label("Activate", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                .padding(.horizontal)
                .disabled(vm.isLoading || vm.code.isEmpty)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .padding()
        }
        .navigationTitle("Activate")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $goToLogin) {
            LoginView()
        }
        .onChange(of: vm.successMessage) { _, newVal in
            if newVal != nil { goToLogin = true }
        }
    }
}

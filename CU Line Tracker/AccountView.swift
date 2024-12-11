import SwiftUI

struct AccountView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Account Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.blue)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(viewModel.currentUser?.email ?? "Unknown")")
                    .font(.headline)
                    .foregroundColor(AppColors.blue)
                
                Text("Email Verified: \(viewModel.isEmailVerified ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(viewModel.isEmailVerified ? .green : .red)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
            
            if !viewModel.isEmailVerified {
                Button(action: viewModel.resendVerificationEmail) {
                    Text("Resend Verification Email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            
            Button(action: viewModel.signOut) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            
            Button(action: { showDeleteConfirmation = true }) {
                Text("Delete Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.gold.edgesIgnoringSafeArea(.all))
    }
}

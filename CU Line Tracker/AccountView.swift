import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
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
            
            Spacer()
        }
        .padding()
        .background(AppColors.gold.edgesIgnoringSafeArea(.all))
    }
}

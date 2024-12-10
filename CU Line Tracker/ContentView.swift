import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        Group {
            if let user = viewModel.currentUser {
                if viewModel.isEmailVerified {
                    mainTabView
                } else {
                    emailVerificationView
                }
            } else {
                AuthView()
            }
        }
    }
    
    var mainTabView: some View {
        TabView {
            LineLengthView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("View Lines")
                }
            
            InputLengthView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Update Length")
                }

            ChucksMenuView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Chuck's Menu")
                }

            VStack {
                AccountView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
        }
    }
    
    var emailVerificationView: some View {
        VStack(spacing: 20) {
            Text("Email Verification Required")
                .font(.title)
                .padding()
            
            Text("A verification email has been sent to \(viewModel.currentUser?.email ?? "your email"). Please check your inbox.")
                .padding()
            
            if viewModel.isLoading {
                ProgressView("Sending email...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else {
                Button(action: {
                    viewModel.resendVerificationEmail()
                }) {
                    Text("Resend Verification Email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.blue)
                        .cornerRadius(10)
                }
            }
            
            Button(action: {
                viewModel.signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}

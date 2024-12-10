import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignUp: Bool = false
    
    var body: some View {
        ZStack {
            // Background color
            AppColors.gold.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text(isSignUp ? "Sign Up" : "Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.blue)
                    .padding(.top, 40)
                
                // Input Fields
                VStack(spacing: 16) {
                    // Email Input
                    customTextField(
                        placeholder: "Email (@cedarville.edu)",
                        text: $email,
                        isSecure: false
                    )
                    
                    // Password Input
                    customTextField(
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )
                    
                    // Confirm Password (Sign Up Only)
                    if isSignUp {
                        customTextField(
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true
                        )
                    }
                }
                .padding(.horizontal)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView("Please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.blue))
                        .padding()
                } else {
                    // Sign In/Sign Up Button
                    Button(action: {
                        if isSignUp {
                            viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
                        } else {
                            viewModel.signIn(email: email, password: password)
                        }
                    }) {
                        Text(isSignUp ? "Sign Up" : "Sign In")
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
                
                // Toggle Between Sign In/Sign Up
                Button(action: { isSignUp.toggle() }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(AppColors.blue)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Cedarville Line Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Custom TextField Component
    private func customTextField(placeholder: String, text: Binding<String>, isSecure: Bool) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.6)) // Darker placeholder color for visibility
                    .font(.system(size: 16, weight: .medium)) // Increased font weight for better readability
                    .padding(.leading, 15)
            }
            if isSecure {
                SecureField("", text: text)
                    .padding()
                    .foregroundColor(AppColors.blue) // Text color
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.blue, lineWidth: 1))
            } else {
                TextField("", text: text)
                    .padding()
                    .foregroundColor(AppColors.blue) // Text color
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.blue, lineWidth: 1))
            }
        }
        .frame(height: 50) // Ensures a consistent height
    }
}

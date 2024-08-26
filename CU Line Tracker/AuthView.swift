import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String = ""

    let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
    let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue

    var body: some View {
        ZStack {
            // Gold background
            goldColor
                .edgesIgnoringSafeArea(.all) // This makes sure the background fills the entire screen

            VStack(spacing: 20) {
                Spacer() // Pushes the content towards the center

                // Main heading
                Text(isSignUp ? "Sign Up" : "Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(blueColor)

                // Email input field
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Password input field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }

                // Sign In / Sign Up button
                Button(action: {
                    isSignUp ? signUp() : signIn()
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(blueColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                // Toggle between sign up and sign in
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(blueColor)
                }

                // Resend verification email for signed-in users
                if !isSignUp {
                    Button(action: {
                        sendEmailVerification()
                    }) {
                        Text("Resend Verification Email")
                            .font(.footnote)
                            .foregroundColor(blueColor)
                    }
                }

                Spacer() // Pushes the content towards the center
            }
            .padding() // Padding to avoid content hitting the edges
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                if let user = Auth.auth().currentUser, !user.isEmailVerified {
                    errorMessage = "Please verify your email address."
                } else {
                    errorMessage = ""
                    print("Signed in!")
                }
            }
        }
    }

    private func signUp() {
        guard email.hasSuffix("@cedarville.edu") else {
            errorMessage = "You must use a Cedarville University email address."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = ""
                sendEmailVerification()
            }
        }
    }

    private func sendEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    errorMessage = "Failed to send verification email: \(error.localizedDescription)"
                } else {
                    errorMessage = "Verification email sent. Please check your inbox."
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

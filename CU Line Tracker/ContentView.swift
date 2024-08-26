import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var pandaExpressLine: Int = 0
    @State private var chickFilALine: Int = 0
    @State private var chucksLine: Int = 0
    @State private var user: User? = nil
    @State private var isEmailVerified: Bool = false
    @State private var isShowingVerificationPrompt = false

    var body: some View {
        Group {
            if let user = user {
                if isEmailVerified {
                    authenticatedView
                } else {
                    emailVerificationView
                }
            } else {
                AuthView()
            }
        }
        .onAppear {
            checkAuthentication()
        }
    }

    var authenticatedView: some View {
        TabView {
            LineLengthView(pandaExpressLine: $pandaExpressLine, chickFilALine: $chickFilALine, chucksLine: $chucksLine)
                .tabItem {
                    Image(systemName: "list.number")
                    Text("View Lines")
                }
            
            InputLengthView(pandaExpressLine: $pandaExpressLine, chickFilALine: $chickFilALine, chucksLine: $chucksLine)
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Update Length")
                }

            ChucksMenuView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Chuck's Menu")
                }

            AccountView()
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

            Text("A verification email has been sent to \(user?.email ?? "your email"). Please check your inbox.")
                .padding()

            Button(action: {
                resendVerificationEmail()
            }) {
                Text("Resend Verification Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func checkAuthentication() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                if user.email?.hasSuffix("@cedarville.edu") ?? false {
                    self.user = user
                    self.isEmailVerified = user.isEmailVerified
                } else {
                    // Sign out if email is not a Cedarville one
                    try? Auth.auth().signOut()
                    self.user = nil
                }
            } else {
                self.user = nil
            }
        }
    }

    private func resendVerificationEmail() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    print("Failed to send verification email: \(error.localizedDescription)")
                } else {
                    print("Verification email sent.")
                }
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

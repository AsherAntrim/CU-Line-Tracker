import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @State private var userEmail: String = ""
    @State private var isEmailVerified: Bool = false

    let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
    let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue

    var body: some View {
        VStack(spacing: 20) {
            Text("Account Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(blueColor) // Blue text color
                .padding(.top, 40)

            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(userEmail)")
                    .font(.headline)
                    .foregroundColor(blueColor) // Blue text for email

                Text("Email Verified: \(isEmailVerified ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(isEmailVerified ? .green : .red) // Green or red depending on verification status
            }
            .padding()
            .background(Color.white.opacity(0.8)) // Light background with opacity for clarity
            .cornerRadius(10)
            .shadow(radius: 5) // Add shadow for depth

            Button(action: signOut) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5) // Add shadow to button
            }
            .padding()

            Spacer()
        }
        .onAppear {
            loadUserDetails()
        }
        .padding()
        .background(goldColor.edgesIgnoringSafeArea(.all)) // Gold background for the whole view
    }

    private func loadUserDetails() {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email ?? "Unknown"
            self.isEmailVerified = user.isEmailVerified
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            // Handle what happens after sign-out (e.g., navigate to login screen)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LineData {
    let place: String
    let lineLength: Int
    let lastUpdated: String
}

class AppViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isEmailVerified = false
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    @Published var pandaExpressLine: Int = 0
    @Published var chickFilALine: Int = 0
    @Published var chucksLine: Int = 0
    @Published var cafeLine: Int = 0 // NEW LINE
    
    @Published var lastUpdatedPandaExpress: String = "N/A"
    @Published var lastUpdatedChickFilA: String = "N/A"
    @Published var lastUpdatedChucks: String = "N/A"
    @Published var lastUpdatedCafe: String = "N/A" // NEW LINE
    
    private let ref = Database.database().reference()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user, user.email?.hasSuffix("@cedarville.edu") == true {
                self.currentUser = user
                self.isEmailVerified = user.isEmailVerified
                if self.isEmailVerified {
                    self.fetchAllLineLengths()
                }
            } else {
                try? Auth.auth().signOut()
                self.currentUser = nil
            }
        }
    }
    
    func signIn(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            defer { self?.isLoading = false }
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let user = Auth.auth().currentUser, !user.isEmailVerified {
                self.errorMessage = "Please verify your email before continuing."
            } else {
                self.errorMessage = ""
            }
        }
    }
    
    func fetchAllLineLengths() {
        fetchLineLength(for: "pandaExpress",
                        binding: \.pandaExpressLine,
                        lastUpdatedBinding: \.lastUpdatedPandaExpress)
        fetchLineLength(for: "chickFilA",
                        binding: \.chickFilALine,
                        lastUpdatedBinding: \.lastUpdatedChickFilA)
        fetchLineLength(for: "chucks",
                        binding: \.chucksLine,
                        lastUpdatedBinding: \.lastUpdatedChucks)
        fetchLineLength(for: "theCafe",
                        binding: \.cafeLine,
                        lastUpdatedBinding: \.lastUpdatedCafe)
    }

    
    func signUp(email: String, password: String, confirmPassword: String) {
        guard email.hasSuffix("@cedarville.edu") else {
            errorMessage = "You must use a Cedarville University email address."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            defer { self?.isLoading = false }
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.errorMessage = ""
                self.sendEmailVerification()
            }
        }
    }
    
    func sendEmailVerification() {
        guard let user = Auth.auth().currentUser else { return }
        isLoading = true
        user.sendEmailVerification { [weak self] error in
            defer { self?.isLoading = false }
            if let error = error {
                self?.errorMessage = "Failed to send verification email: \(error.localizedDescription)"
            } else {
                self?.errorMessage = "Verification email sent. Please check your inbox."
            }
        }
    }
    
    func resendVerificationEmail() {
        sendEmailVerification()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @Published var lineData: [LineData] = [
            LineData(place: "Panda Express", lineLength: 7, lastUpdated: "10/23/24, 18:17"),
            LineData(place: "Chick-fil-A", lineLength: 7, lastUpdated: "10/23/24, 18:17"),
            LineData(place: "Chuck's", lineLength: 2, lastUpdated: "10/23/24, 18:17"),
            LineData(place: "The Café", lineLength: 0, lastUpdated: "")
        ]
    
    private func fetchLineLength(for place: String,
                                 binding: ReferenceWritableKeyPath<AppViewModel, Int>,
                                 lastUpdatedBinding: ReferenceWritableKeyPath<AppViewModel, String>) {
        let path = "lineLengths/\(place)/latestUpdate"
        print("Fetching data from path: \(path)")
        
        ref.child(path).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            print("Snapshot value for \(path): \(snapshot.value ?? "nil")")
            
            DispatchQueue.main.async {
                guard let update = snapshot.value as? [String: Any],
                      let lineLength = update["lineLength"] as? Int,
                      let timestamp = update["timestamp"] as? Int else {
                          print("Failed to fetch data or incorrect format for \(path)")
                          self[keyPath: binding] = 0
                          self[keyPath: lastUpdatedBinding] = "N/A"
                          return
                      }
                self[keyPath: binding] = lineLength
                self[keyPath: lastUpdatedBinding] = self.formatTimestamp(timestamp)
                print("Updated \(place): \(lineLength), \(self[keyPath: lastUpdatedBinding])")
            }
        }
    }


    
    private func formatTimestamp(_ timestamp: Int) -> String {
        if timestamp == 0 { return "N/A" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func updateLineLength(placeKey: String, newLength: Int, completion: @escaping (Bool, String) -> Void) {
        guard let user = currentUser else {
            completion(false, "You must be signed in to update.")
            return
        }
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let userId = user.uid
        
        ref.child("userUpdates/\(userId)/\(placeKey)/lastUpdateTimestamp").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            if let lastUpdateTimestamp = snapshot.value as? Int {
                let timeSinceLastUpdate = currentTime - lastUpdateTimestamp
                if timeSinceLastUpdate < 300 {
                    completion(false, "You can only update the line every 5 minutes.")
                    return
                }
            }
            let newUpdate: [String: Any] = [
                "lineLength": newLength,
                "timestamp": currentTime
            ]
            
            self.ref.child("lineLengths/\(placeKey)/latestUpdate").setValue(newUpdate) { error, _ in
                if let error = error {
                    completion(false, "Error updating line length: \(error.localizedDescription)")
                } else {
                    self.ref.child("userUpdates/\(userId)/\(placeKey)/lastUpdateTimestamp").setValue(currentTime) { error, _ in
                        if let error = error {
                            completion(false, "Error saving last update time: \(error.localizedDescription)")
                        } else {
                            completion(true, "Line length updated successfully.")
                            self.fetchAllLineLengths()
                        }
                    }
                }
            }
        }
    }
}

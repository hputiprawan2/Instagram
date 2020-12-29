//
//  AuthManager.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import FirebaseAuth


public class AuthManager {
    static let shared = AuthManager()

    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - Check if username is available
         - Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username, password: password) { canCreate in
            if canCreate {
                /*
                 - Create an account
                 - Insert an account to the DB
                 */
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard error == nil, result != nil else {
                        // Firebase auth is unable to create an account
                        completion(false)
                        return
                    }
                    // Insert into DB
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { (inserted) in
                        if inserted {
                            // Successfully inserted a new user to DB
                            completion(true)
                            return
                        }
                        else {
                            // Failed to insert a new user to DB
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                // Either username or email doesn't exist
                completion(false)
            }
            
            
        }
    }

    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        // Check if user log in with username or email
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            print(username)
        }
        
    }
}



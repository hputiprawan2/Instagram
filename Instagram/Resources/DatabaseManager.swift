//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import FirebaseDatabase

// Mark: - Private

public class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Database.database().reference()
    
    /// Check if username and email are available
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, password: String, completion: (Bool) -> Void) {
        // TODO
        completion(true)
    }
    
    /// Insert new user to DB
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: Async callback for result if db entry succeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        db.child(email.safeDbKey()).setValue(["username": username]) { error, _ in if error == nil{
                // success
                completion(true)
                return
            }
            else {
                // fail
                completion(false)
                return
            }
        }
    }
    
}

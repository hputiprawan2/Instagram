//
//  ViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        
//        // Forced signed out --* For DEBUG *--
//        do {
//            try Auth.auth().signOut()
//        }
//        catch {
//            print("Failed to sign out")
//        }
        
    }

    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show login
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen // so user cannot swipe away
            present(loginVC, animated: false)
        }
    }
}


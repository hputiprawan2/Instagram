//
//  SettingViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View Controller to show user settings; Final - cannot subclass
final class SettingViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]() // 2D array for multiple sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModel()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        // Get called after all the other subviews have laid out, so it count the safe area
        tableView.frame = view.bounds
    }
    
    private func configureModel() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in
                self?.didTapInviteFriends()
            },
            SettingCellModel(title: "Save Original Posts") { [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Services") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help / Feedback") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingCellModel(title: "Log Out") { [weak self] in
                // weak self - so we don't cause the memory leak since we're referencing self
                self?.didTapLogOut()
            }
        ])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
    
    private func didTapInviteFriends() {
        // Show share sheet to invite friends
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    enum SettingURLType {
        case terms, privacy, help
    }
    private func openURL(type: SettingURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://www.facebook.com/help/instagram/termsofuse"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapLogOut() {
        
        let actionSheet = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            // .destructive = red button
            
            // handler: discard the result
            AuthManager.shared.logOut { (success) in
                DispatchQueue.main.async {
                    if success {
                        // present log in
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen // so user cannot swipe away
                        self.present(loginVC, animated: true) {
                            // Get rid of the setting and switch back to the main tab, so when user log back in again they are back on the home tab rather than on Settings
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        // error occured
                        fatalError("Failed to Signed Out")
                    }
                }
            }
        }))
        
        // popoverPresentationController - make sure it doesn't crash on iPad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator // > (go to next) in UI
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
}

//
//  SettingViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit

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
        let section = [
            SettingCellModel(title: "Log Out") { [weak self] in
                // weak self - so we don't cause the memory leak since we're referencing self
                self?.didTapLogOut()
            }
        ]
        data.append(section)
    }
    
    private func didTapLogOut() {
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
                    print("Failed to Signed Out")
                }
            }
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
}

//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

/// Notification View Controller - table view
final class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true // when animation stop, automatically hide
        spinner.tintColor = .label
        return spinner
    }()
        
    private lazy var noNotificationsView = NoNotificationView() // lazy - only instantiates only when it get called
    
    private var models = [UserNotification]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications" // only set the header title, not bottom icon
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
//        spinner.startAnimating()
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "joe",
                            name: (first: "", last: ""),
                            profilePhoto: URL(string: "https://www.google.com")!,
                            birthDate: Date(),
                            gender: .male,
                            bio: "",
                            counts: UserCount(followers: 1,
                                              following: 1,
                                              posts: 1),
                            joinDate: Date())
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://www.google.com/")!,
                                postURL: URL(string: "https://www.google.com/")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUsers: [],
                                owner: user)
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                                         text: "Hello World",
                                         user: user)
            models.append(model)
        }
    }
    
    private func addNoNotificationView() {
        // Layout only when there is no notification
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.width/2,
                                           height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            // Like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .follow:
            // Follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
//            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NotificationViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            // Open the post
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            // Don't have a follow button in notification for post
            fatalError("Dev Issue: Should never get called")
        }
        
    }
}

extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("Tapped Follow button")
        // Perform DB update
    }
}

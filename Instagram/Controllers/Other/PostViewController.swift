//
//  PostViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit

    /*
     Section
     - Header model
     Section
     - Post cell model
     Section
     - Action buttons cell model
     Section
     - n Number of general models for comment
     */
/// States of a rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) // Post
    case actions(provider: String) // Show like button, comment, share
    case comments(comments: [PostComment])
}

/// Models of a rendered post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {

    private let model: UserPost?
    
    private var renderedModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        
        // Header
        renderedModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        // Post
        renderedModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        // Action
        renderedModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        // 4 Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(identifier: "123\(x)",
                                        username: "@dave",
                                        text: "Great post!",
                                        createdDate: Date(),
                                        likes: []))
        }
        
        renderedModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderedModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderedModels[section].renderType {
        case .header(_): return 1
        case .primaryContent(_): return 1
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderedModels[indexPath.section]
        switch model.renderType {
        case .header(let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
            return cell
        case .primaryContent(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .actions(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
            return cell
        case .comments(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderedModels[indexPath.section]
        switch model.renderType {
        case .header(_): return 60
        case .primaryContent(_): return 50
        case .actions(_): return tableView.width
        case .comments(let user): return 70
        }
    }
}


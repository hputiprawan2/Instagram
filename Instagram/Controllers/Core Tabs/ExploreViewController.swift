//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit

class ExploreViewController: UIViewController {

    private var models = [UserPost]()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var collectionView: UICollectionView?
    
    /// Dim the screen when tap search
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0.4
        return view
    }()
    
    private var tabSearchCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureSearchBar()
        configureTabSearch()
        configureExploreCollection()
        configureDimmedView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabSearchCollectionView?.frame = CGRect(x: 0,
                                                y: view.safeAreaInsets.top,
                                                width: view.width,
                                                height: 72) // 52(cell) + 10(buffer*2)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureTabSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabSearchCollectionView?.backgroundColor = .yellow
        tabSearchCollectionView?.isHidden = true
        guard let tabSearchCollectionView = tabSearchCollectionView else {
            return
        }
        tabSearchCollectionView.delegate = self
        tabSearchCollectionView.dataSource = self
        view.addSubview(tabSearchCollectionView)
    }
    
    private func configureExploreCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, //4=buffer, 3=number of photo
                                 height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    // Gesture: when tap in dimmed area, will be out of search
    private func configureDimmedView() {
        view.addSubview(dimmedView) // Add dimmedView AFTER collectionView, so it's on top
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabSearchCollectionView {
            return 0
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabSearchCollectionView {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.configure(with: <#T##UserPost#>)
        cell.configure(debug: "test")
        return cell
    }
    
    // When tap on a cell should open up the actual post
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        let model = models[indexPath.row]
        if collectionView == tabSearchCollectionView {
            // Change search context
            return
        }
        
        /// MARK - Mock Model
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
        
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        query(text)
    }
    
    private func query(_ text: String) {
        // Perform text in the backend
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }) { (done) in
            if done {
                self.tabSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder() // Get rid of keyboard
        navigationItem.rightBarButtonItem = nil // Get rid of Cancel button
        self.tabSearchCollectionView?.isHidden = true // Hide suggestion tab
        
        UIView.animate(withDuration: 0.2, animations: {self.dimmedView.alpha = 0}) { (done) in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
}

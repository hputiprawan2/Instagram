//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by Hanna Guest on 12/30/20.
//

import UIKit

// Tab icons between your posts and tagged photos
class ProfileTabsCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileTabsCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

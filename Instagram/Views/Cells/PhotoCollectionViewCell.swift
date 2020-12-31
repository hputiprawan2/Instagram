//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Hanna Guest on 12/30/20.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        
        // For accessibility; read out loud
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open posts"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost) {
        let url = model.thumbnailImage
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
//            photoImageView.image = UIImage(data: data!)
//        }) // have to handle caching, so using API instead
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    // For test purposes
    public func configure(debug imageName: String) {
        photoImageView.image = UIImage(named: imageName)
    }
    
}

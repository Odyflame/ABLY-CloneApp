//
//  BannerCollectionViewCell.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SnapKit
import Then

class BannerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: BannerCollectionViewCell.self)
    
    enum Constant {
        static let spageImage = "spareImage"
    }
    
    lazy var bannerImageView = UIImageView().then {
        $0.image = UIImage(named: Constant.spageImage)
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        addSubview(bannerImageView)
        
        bannerImageView.snp.makeConstraints { make in
            make.leading.bottom.top.trailing.equalTo(self)
        }
    }
    
    func configure(urlLink: String?) {
        guard let urlLink = urlLink,
              let url = URL(string: urlLink) else {
            return
        }
        
        self.bannerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.spageImage))
    }
}


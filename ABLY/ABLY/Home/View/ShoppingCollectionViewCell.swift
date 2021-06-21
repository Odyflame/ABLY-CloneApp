//
//  ShoppingCollectionViewCell.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SnapKit
import Then
import Network
import SDWebImage
import RxSwift
import RxCocoa

class ShoppingCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ShoppingCollectionViewCell.self)
    
    enum Constant {
        static let disCountLabel = "0%"
        static let priceLabel = "0"
        static let goodsNameLabel = "준비중입니다"
        static let sellingCountLabel = "구매 수량 확인중"
    }
    
    lazy var goodsImage = UIImageView().then {
        $0.image = UIImage(named: "spareImage")
    }
    
    lazy var heartButton = UIButton().then {
        $0.setImage(UIImage(named: "iconCardZzim"), for: .normal)
        $0.setImage(UIImage(named: "iconCardZzimSelected"), for: .selected)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [goodsStackView, sellingStackView]).then {
        $0.axis = .vertical
        $0.spacing = 17
    }
    
    lazy var goodsStackView = UIStackView(arrangedSubviews: [titleStackView, goodsNameLabel]).then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    lazy var titleStackView = UIStackView(arrangedSubviews: [discountLabel, priceLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 5
    }
    
    lazy var discountLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        $0.text = Constant.disCountLabel
    }
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        $0.text = Constant.priceLabel
        $0.textColor = .black
    }
    
    lazy var goodsNameLabel = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.text = Constant.goodsNameLabel
        $0.numberOfLines = 0
        $0.textColor = Color.gray
    }
    
    lazy var sellingStackView = UIStackView(arrangedSubviews: [newKeywordImage, sellingCountLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 5
    }
    
    lazy var newKeywordImage = UIImageView().then {
        $0.image = UIImage(named: "imgBadgeNew")
    }
    
    lazy var sellingCountLabel = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        $0.text = Constant.sellingCountLabel
        $0.textColor = Color.gray
    }
    
    let disposeBag = DisposeBag()
    var data: GoodsResult?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        RxBind()
    }
    
    func RxBind() {
        heartButton.rx.tap
            .subscribe(onNext: {
                guard let data = self.data else { return }
                
                if self.heartButton.isSelected {
                    GoodsManager.shared.delete(good: data)
                } else {
                    GoodsManager.shared.insert(good: data)
                }
                
                self.heartButton.isSelected.toggle()
                
                NotificationCenter.default.post(name: NSNotification.Name.dataChanged, object: nil)
                
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: GoodsResult) {
        
        self.data = data
        if let price = data.price {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current

            let num = NSNumber(value: Int32(price))
            let priceString = currencyFormatter.string(from: num)
            priceLabel.text = priceString
        }
        goodsNameLabel.text = "\(data.name ?? "")"
        
        GoodsManager.shared.fetch(id: data.id) { good in
            if let good = good {
                self.heartButton.isSelected = true
            } else {
                self.heartButton.isSelected = false
            }
        }
        
        if let isNew = data.isNew, isNew {
            newKeywordImage.image = UIImage(named: "imgBadgeNew")
        }
        
        if let sellCount = data.sellCount, sellCount >= 10 {
            sellingCountLabel.text = "\(sellCount)개 구매중"
        }
        
        if let price = data.price,
              let actualPrice = data.actualPrice {
            let percent = Double(actualPrice - price) / Double(actualPrice) * 100
            discountLabel.text = "\(Int(percent))%"
        }
        
        guard let link = data.image,
              let imageURL = URL(string: link) else {
            return
        }
        
        goodsImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "spareImage"))
    }
    
    func configureInit() {
        priceLabel.text = ""
        goodsImage.image = nil
        discountLabel.text = ""
        newKeywordImage.image = nil
        sellingCountLabel.text = ""
        goodsNameLabel.text = ""
    }
    
    func configureLayout() {
        backgroundColor = .white
        contentView.addSubview(goodsImage)
        contentView.addSubview(heartButton)
        contentView.addSubview(goodsStackView)
        contentView.addSubview(sellingStackView)
        
        goodsImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(20)
            make.width.height.equalTo(80)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.top).offset(8)
            make.trailing.equalTo(goodsImage.snp.trailing).offset(-8)
        }
        
        goodsStackView.snp.makeConstraints { make in
            make.leading.equalTo(goodsImage.snp.trailing).offset(12)
            make.top.equalTo(contentView.snp.top).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-22)
        }
        
        sellingStackView.snp.makeConstraints { make in
            make.top.equalTo(goodsStackView.snp.bottom).offset(17)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
            make.leading.equalTo(goodsImage.snp.trailing).offset(12)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

}

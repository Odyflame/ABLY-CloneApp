//
//  BannerHeaderView.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import DesignHelper
import Network

class BannerHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "BannerHeaderView"
    var links: [BannerResult] = []
    private var timer = Timer()
    let timerInterval: TimeInterval = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startTimer()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var pageIndexView = PageIndexLabel().then {
        $0.configure(id: 1, count: 1)
    }
    
    func configure(list: [BannerResult]) {
        self.links = list
        pageIndexView.configure(id: 1, count: links.count)
        collectionView.reloadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        
        return collectionView
    }()
    
    func configureLayout() {
        addSubview(collectionView)
        addSubview(pageIndexView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self)
        }
        
        pageIndexView.snp.makeConstraints { make in
            make.trailing.equalTo(collectionView.snp.trailing).offset(-16)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-16)
        }
    }
    
    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { timer in
          
            guard self.collectionView.bounds.width > 0 else {
                return
            }
            let index = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.width)
            var nextIndex = index + 1

            if nextIndex == self.links.count {
                nextIndex = 0
            }
            
            let newOffset = CGFloat(nextIndex) * CGFloat(self.collectionView.bounds.width)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.contentOffset.x = newOffset
            }) { (_) in
                self.infiniteScroll()
            }
        })
    }
    
    fileprivate func infiniteScroll() {
        
        if collectionView.contentOffset.x == (self.collectionView.bounds.width * CGFloat((links.count))) {
            collectionView.contentOffset.x = 0
        }
        
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        pageIndexView.configure(id: index + 1, count: links.count)
    }
    
    fileprivate func stopTimer() {
        self.timer.invalidate()
    }
}


extension BannerHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.reuseIdentifier, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(urlLink: links[indexPath.item].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        pageIndexView.configure(id: sourceIndexPath.item, count: links.count)
    }
}

extension BannerHeaderView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension BannerHeaderView {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        infiniteScroll()
        startTimer()
    }
}

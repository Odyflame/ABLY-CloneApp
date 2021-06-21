//
//  FavoriteViewController.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SnapKit
import Then
import Network

class FavoriteViewController: UIViewController {
    
    enum Constant {
        static let title = "좋아요"
    }
    
    lazy var favoriteShoppingCollectionViewController: UICollectionView = {
        let flowLayout = DynamicFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(
            ShoppingCollectionViewCell.self,
            forCellWithReuseIdentifier: ShoppingCollectionViewCell.reuseIdentifier
        )
        
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .lightGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var myFavorites = [GoodsResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyFavoriteData()
        configureLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeData),
            name: Notification.Name.dataChanged,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = Constant.title
    }
    
    func getMyFavoriteData() {
        GoodsManager.shared.fetch { goods in
            
            if let goods = goods {
                var newData = [GoodsResult]()
                for good in goods {
                    let newGood = GoodsManager.shared.convertGoodsToResult(good: good)
                    newData.append(newGood)
                }
                
                self.myFavorites = newData
            } else {
                self.myFavorites = []
            }
            
            self.favoriteShoppingCollectionViewController.reloadData()
        }
    }
    
    func configureLayout() {
        view.addSubview(favoriteShoppingCollectionViewController)
        
        favoriteShoppingCollectionViewController.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    @objc func changeData() {
        getMyFavoriteData()
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.reuseIdentifier, for: indexPath) as? ShoppingCollectionViewCell else {
            return ShoppingCollectionViewCell()
        }
        
        cell.configure(data: myFavorites[indexPath.item])
        cell.heartButton.isHidden = true
        
        return cell
    }
}


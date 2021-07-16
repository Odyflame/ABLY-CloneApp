//
//  HomeViewController.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Network

class HomeViewController: UIViewController {
    
    enum Constant {
        static let title = "홈"
        static let bannerHeight = 263
    }
    
    lazy var bannerHeaderCollectionViewController = BannerHeaderView()
    
    lazy var homeShoppingCollectionViewController: UICollectionView = {
        let flowLayout = DynamicFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(BannerHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: BannerHeaderView.reuseIdentifier)
        
        collectionView.register(
            ShoppingCollectionViewCell.self,
            forCellWithReuseIdentifier: ShoppingCollectionViewCell.reuseIdentifier
        )
        
        
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var viewModel: HomeViewModelType = HomeViewModel()
    let disposeBag = DisposeBag()
    var goods = [GoodsResult]()
    var isPaging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRefresh()
        RxBind()
        viewModel.input.getBannerAndShoppingData()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = Constant.title
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(scrollRefresh), for: .valueChanged)
        
        self.homeShoppingCollectionViewController.refreshControl = refresh
    }
    
    func RxBind() {
        viewModel.output.banners
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                
                guard let list = self?.viewModel.output.banners.value else { return }
                
                DispatchQueue.main.async {
                    self?.bannerHeaderCollectionViewController.configure(list: list)
                }
                
            }).disposed(by: disposeBag)
        
        viewModel.output.goods
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                
                self?.goods = self?.viewModel.output.goods.value ?? []
                self?.isPaging = false
                
                DispatchQueue.main.async {
                    self?.homeShoppingCollectionViewController.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func configureLayout() {
        //        view.addSubview(bannerHeaderCollectionViewController)
        view.addSubview(homeShoppingCollectionViewController)
        
        //        bannerHeaderCollectionViewController.snp.makeConstraints { make in
        //            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
        //            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        //            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        //            make.height.equalTo(Constant.bannerHeight)
        //        }
        
        homeShoppingCollectionViewController.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func scrollRefresh(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        viewModel.input.getBannerAndShoppingData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.reuseIdentifier, for: indexPath) as? ShoppingCollectionViewCell else {
            return ShoppingCollectionViewCell()
        }
        
        cell.configureInit()
        cell.configure(data: goods[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BannerHeaderView.reuseIdentifier,
                for: indexPath ) as? BannerHeaderView else {
            return UICollectionReusableView()
        }
        
        header.configure(list: self.viewModel.output.banners.value)
        
        return header
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

extension HomeViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) && !isPaging {
            isPaging = true
            guard let id = self.goods.last?.id else { return }
            self.viewModel.input.getNextShoppingData(id: id)
        }
    }
}

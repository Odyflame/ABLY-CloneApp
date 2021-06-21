//
//  PageIndexLabel.swift
//  DesignHelper
//
//  Created by apple on 2021/06/18.
//

import UIKit
import SnapKit
import Then

public class PageIndexLabel: UIView {
    lazy var pageIndex = UILabel().then {
        $0.text = "0/0"
        $0.textColor = .white
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 12.5
    }
    
    public func configure(id: Int, count: Int) {
        pageIndex.text = "\(id)/\(count)"
    }
    
    func configureLayout() {
        addSubview(pageIndex)
        
        pageIndex.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(11)
            make.trailing.equalTo(self.snp.trailing).offset(-11)
            make.top.equalTo(self.snp.top).offset(4)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
    }
}

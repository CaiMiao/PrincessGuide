//
//  CraftSummaryTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

protocol CraftSummaryTableViewCellDelegate: class {
    func craftSummaryTableViewCell(_ craftSummaryTableViewCell: CraftSummaryTableViewCell, didSelect consume: Craft.Consume)
}

class CraftSummaryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let titleLabel = UILabel()
    let layout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    weak var delegate: CraftSummaryTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        titleLabel.text = NSLocalizedString("Total Items", comment: "")
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        layout.itemSize = CGSize(width: 64, height: 92)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(92)
            make.bottom.equalToSuperview()
        }
        
        collectionView.register(CraftSummaryCollectionViewCell.self, forCellWithReuseIdentifier: CraftSummaryCollectionViewCell.description())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var consumes = [Craft.Consume]()
    func configure(for equipment: Equipment) {
        consumes = equipment.recursiveConsumes
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.craftSummaryTableViewCell(self, didSelect: consumes[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CraftSummaryCollectionViewCell.description(), for: indexPath) as! CraftSummaryCollectionViewCell
        cell.configure(for: consumes[indexPath.item])
        return cell
    }
}
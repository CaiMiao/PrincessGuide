//
//  AttackPatternView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Gestalt

class AttackPatternView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let layout: UICollectionViewFlowLayout
    let collectionView: UICollectionView

    override init(frame: CGRect) {
        
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.collectionView.indicatorStyle = theme.indicatorStyle
        }
        
        let height = PatternCollectionViewCell().intrinsicContentSize.height
        layout.itemSize = CGSize(width: 64, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(height)
        }
        
        collectionView.register(PatternCollectionViewCell.self, forCellWithReuseIdentifier: PatternCollectionViewCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = .clear
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pattern?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PatternCollectionViewCell.description(), for: indexPath) as! PatternCollectionViewCell
        
        if let pattern = pattern {
            if let unit = unit {
                cell.configure(for: pattern, index: indexPath.item, unit: unit)
            } else if let enemy = enemy {
                cell.configure(for: pattern, index: indexPath.item, enemy: enemy)
            }
        }
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var pattern: AttackPattern?
    private var unit: Card?
    private var enemy: Enemy?
    
    func configure(for pattern: AttackPattern, unit: Card) {
        self.pattern = pattern
        self.unit = unit
        collectionView.reloadData()
    }

    func configure(for pattern: AttackPattern, enemy: Enemy) {
        self.pattern = pattern
        self.enemy = enemy
        collectionView.reloadData()
    }
}

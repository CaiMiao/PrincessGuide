//
//  CDCommentTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDCommentTableViewCell: UITableViewCell, CardDetailConfigurable {

    let commentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
            themable.commentLabel.textColor = theme.color.body
        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        commentLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for item: CardDetailItem) {
        guard case .comment(let comment) = item else {
            fatalError()
        }
        configure(for: comment)
    }
    
    func configure(for comment: Card.Comment) {
        commentLabel.text = comment.description.replacingOccurrences(of: "\\n", with: "\n")
    }
    
}

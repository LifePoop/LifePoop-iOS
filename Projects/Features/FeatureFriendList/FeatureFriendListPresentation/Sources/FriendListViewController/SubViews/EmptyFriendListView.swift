//
//  EmptyFriendListView.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem
import Utils

final class EmptyFriendListView: UIView {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.inviteFriendsAndEncourageBowelMovements
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = ColorAsset.gray600.color
        label.textAlignment = .center
        return label
    }()
    
    private let characterImageView = UIImageView(image: ImageAsset.friendsEmptyStatus.original)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        
        addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.centerY).inset(24)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(characterImageView.snp.centerX)
            make.top.equalTo(characterImageView.snp.bottom).offset(24)
        }
    }
}

//
//  FriendListViewController.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class FriendListViewController: LifePoopViewController, ViewType {
    
    private let rightBarButtonItem = UIBarButtonItem(image: ImageAsset.iconAdd.original)
    
    private lazy var friendListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            FriendListCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendListCollectionViewCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let emptyFriendListView: EmptyFriendListView = {
        let emptyFriendListView = EmptyFriendListView()
        emptyFriendListView.isHidden = true
        return emptyFriendListView
    }()
    
    private var disposeBag = DisposeBag()
    public var viewModel: FriendListViewModel?

    public func bindInput(to viewModel: FriendListViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        rightBarButtonItem.rx.tap
            .bind(to: input.didTapInvitationButton)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendListViewModel) {
        let output = viewModel.output
        
        output.navigationTitle
            .withUnretained(self)
            .bind(onNext: { `self`, title in
                self.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        output.shouldShowEmptyList
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                self.friendListCollectionView.isHidden = true
                self.emptyFriendListView.isHidden = false
            })
            .disposed(by: disposeBag)

        output.shouldShowFriendList
            .do(onNext: { [weak self] _ in
                self?.emptyFriendListView.isHidden = true
                self?.friendListCollectionView.isHidden = false
            })
            .bind(to: friendListCollectionView.rx.items(
                cellIdentifier: FriendListCollectionViewCell.identifier,
                cellType: FriendListCollectionViewCell.self)
            ) { _, friend, cell in

                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)
    }
    
    public override func configureUI() {
        super.configureUI()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let spacer = UIBarButtonItem.fixedSpace(14)
        navigationItem.rightBarButtonItems = [spacer, rightBarButtonItem]
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
        view.addSubview(friendListCollectionView)
        friendListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(emptyFriendListView)
        emptyFriendListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FriendListViewController: UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 50
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
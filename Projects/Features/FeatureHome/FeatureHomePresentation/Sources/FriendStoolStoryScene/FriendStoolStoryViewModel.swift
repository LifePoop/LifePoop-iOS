//
//  FriendStoolStoryViewModel.swift
//  FeatureHomePresentation
//
//  Created by Lee, Joon Woo on 2023/06/25.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeCoordinatorInterface
import FeatureHomeDIContainer
import FeatureHomeUseCase
import Utils

public final class FriendStoolStoryViewModel: ViewModelType {
    
    enum ScreenSide {
        case left
        case right
    }
    
    public struct Input {
        let viewDidLayoutSubviews = PublishRelay<Void>()
        let didTapCloseButton = PublishRelay<Void>()
        let didTapScreen = PublishRelay<ScreenSide>()
        let didTapCheeringButton = PublishRelay<Void>()
        let didUpdateProgressState = PublishRelay<Int>()
    }
    
    public struct Output {
        let stoolStoryLogs = BehaviorRelay<[StoolStoryLogEntity]>(value: [])
        let shouldUpdateProgressState = PublishRelay<Int>()
        let shouldUpdateShownStoolLog = PublishRelay<StoolLogEntity>()
        let shouldEnableCheeringButton = PublishRelay<Bool>()
        let shouldUpdateFriendStoolLogSummary = PublishRelay<String>()
        let shouldShowLoadingIndicator = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
        
    private var disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?, friend: FriendEntity, stoolStoryLogs: [StoolStoryLogEntity]) {
        var stoolStoryLogs = stoolStoryLogs
        
        input.didTapCloseButton
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .storyCloseButtonDidTap)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .map { stoolStoryLogs }
            .bind(to: output.stoolStoryLogs)
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .filter { stoolStoryLogs.count > 0 }
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                let totalCount = stoolStoryLogs.count
                let currentIndex = 0
                
                self.output.shouldUpdateShownStoolLog.accept(stoolStoryLogs[currentIndex].stoolLog)
                self.output.shouldEnableCheeringButton.accept(
                    stoolStoryLogs[currentIndex].isCheeringUpAvailable
                )
                self.output.shouldUpdateFriendStoolLogSummary.accept(
                    LocalizableString.bowelMovementCountOfFriend(friend.name, totalCount)
                )
            })
            .disposed(by: disposeBag)
        
        input.didTapScreen
            .withLatestFrom(input.didUpdateProgressState) { ($0, $1) }
            .map { side, currentIndex in
                let totalCount = stoolStoryLogs.count
                var currentIndex = currentIndex
                
                switch side {
                case .left:
                    currentIndex = currentIndex <= 0 ? 0 : currentIndex-1
                case .right:
                    currentIndex = currentIndex >= totalCount-1 ? totalCount-1 : currentIndex+1
                }
                
                return currentIndex
            }
            .bind(to: output.shouldUpdateProgressState)
            .disposed(by: disposeBag)

        input.didUpdateProgressState
            .filter { $0 >= 0 }
            .map { stoolStoryLogs[$0].stoolLog }
            .bind(to: output.shouldUpdateShownStoolLog)
            .disposed(by: disposeBag)

        input.didUpdateProgressState
            .filter { $0 >= 0 }
            .observe(on: MainScheduler.asyncInstance)
            .map { stoolStoryLogs[$0].isCheeringUpAvailable }
            .bind(to: output.shouldEnableCheeringButton)
            .disposed(by: disposeBag)
        
        // MARK: 응원하기 버튼 터치 후 임시로 로딩 표시 띄우기 위한 로직, 추후 제거해야 함
        input.didTapCheeringButton
            .do(onNext: { [weak self] _ in
                self?.output.shouldShowLoadingIndicator.accept(true)
            })
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                guard let lastLog = stoolStoryLogs.popLast() else { return }
                let newLog = StoolStoryLogEntity(stoolLog: lastLog.stoolLog, isCheeringUpAvailable: false)
                stoolStoryLogs.append(newLog)
                self?.output.shouldShowLoadingIndicator.accept(false)
            })
            .map { _ in false }
            .bind(to: output.shouldEnableCheeringButton)
            .disposed(by: disposeBag)
    }
}
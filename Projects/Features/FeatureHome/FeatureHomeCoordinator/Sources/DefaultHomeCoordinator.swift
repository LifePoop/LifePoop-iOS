//
//  DefaultHomeCoordinator.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//


import UIKit

import DesignSystem
import FeatureHomeCoordinatorInterface
import FeatureHomePresentation
import FeatureSettingCoordinator
import FeatureSettingCoordinatorInterface
import FeatureStoolLogCoordinator
import Utils

public final class DefaultHomeCoordinator: HomeCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .home
    
    public weak var flowCompletionDelegate: HomeCoordinatorCompletionDelegate?
    
    public init(
        navigationController: UINavigationController,
        flowCompletionDelegate: HomeCoordinatorCompletionDelegate?
    ) {
        self.navigationController = navigationController
        self.flowCompletionDelegate =  flowCompletionDelegate
    }
    
    public func start(animated: Bool) {
        coordinate(by: .flowDidStart(animated: animated))
    }
        
    public func coordinate(by coordinateAction: HomeCoordinateAction) {
        switch coordinateAction {
        case .flowDidStart(let animated):
            pushHomeViewController(animated: animated)
        case .flowDidFinish:
            flowCompletionDelegate?.finishFlow()
        case .stoolLogButtonDidTap:
            startStoolLogCoordinatorFlow()
        case .settingButtonDidTap:
            startSettingCoordinatorFlow()
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {
    func pushHomeViewController(animated: Bool) {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: animated)
    }
    
    func startStoolLogCoordinatorFlow() {
        let stoolLogCoordinator = DefaultStoolLogCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self
        )
        add(childCoordinator: stoolLogCoordinator)

        let bottomSheetController = presentBottomSheetController(
            contentViewController: stoolLogCoordinator.navigationController
        )
        bottomSheetController.delegate = stoolLogCoordinator
        stoolLogCoordinator.start()
    }
    
    func startSettingCoordinatorFlow() {
        let settingCoordinator = DefaultSettingCoordinator(
            navigationController: navigationController,
            completionDelegate: self
        )
        settingCoordinator.start()
    }
}

// MARK: - Supporting Methods

private extension DefaultHomeCoordinator {
    
    func presentBottomSheetController(contentViewController: UIViewController) -> BottomSheetController {
        let parentViewController = navigationController
        let bottomSheetController =  BottomSheetController(
            bottomSheetHeight: navigationController.view.bounds.height*0.5
        )
        
        bottomSheetController.setBottomSheet(contentViewController: contentViewController)
        bottomSheetController.showBottomSheet(toParent: navigationController)

        return bottomSheetController
    }
}

// MARK: - Adopt Coordinator Completion Delegate

extension DefaultHomeCoordinator: SettingCoordinatorCompletionDelegate {
    public func finishFlow() {
        remove(childCoordinator: .setting)
    }
    
    public func finishFlow(by completion: SettingFlowCompletion) {
        remove(childCoordinator: .setting)
        switch completion {
        case .userDidWithdraw, .userDidLogout:
            flowCompletionDelegate?.finishFlow()
        }
    }
}

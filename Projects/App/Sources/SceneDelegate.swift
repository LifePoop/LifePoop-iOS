//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import UIKit

import CoreAuthentication
import CoreDIContainer
import CoreNetworkService
import CoreStorageService
import FeatureFriendListDIContainer
import FeatureFriendListRepository
import FeatureFriendListUseCase
import FeatureHomeDIContainer
import FeatureHomeRepository
import FeatureHomeUseCase
import FeatureLoginDIContainer
import FeatureLoginRepository
import FeatureLoginUseCase
import FeatureReportDIContainer
import FeatureReportUseCase
import FeatureSettingDIContainer
import FeatureSettingRepository
import FeatureSettingUseCase
import SharedDIContainer
import SharedRepository
import SharedUseCase
import Utils

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureNavigationBarAppearance()
        registerAllDependencies()
        
        initKakaoAuthSDKInfo()
        initAppleAuthInfo(with: window)
        
        let rootNavigationController = UINavigationController()
        
        appCoordinator = DefaultAppCoordinator(navigationController: rootNavigationController)
        appCoordinator?.start()
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        KakaoAuthManager.handleLoginUrl(url)
    }
}

// MARK: - Authentication Initialization

private extension SceneDelegate {
    func initKakaoAuthSDKInfo() {
        KakaoAuthManager.initAuthInfo(rightAfter: nil)
    }
    
    func initAppleAuthInfo(with keyWindow: UIWindow?) {
        AppleAuthManager.initAuthInfo(rightAfter: {
            ASAuthorizationControllerProxy.targetWindow = keyWindow
        })
    }
}

// MARK: - Dependency Registration

private extension SceneDelegate {
    func registerAllDependencies() {
        registerCoreDependencies()
        registerSharedDependencies()
        registerLoginDependencies()
        registerHomeDependencies()
        registerSettingDependencies()
        registerReportDependencies()
        registerFriendListDependencies()
    }
    
    func registerCoreDependencies() {
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(StoolLogEntityMapper()) }
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(StoolLogDTOMapper()) }
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(CheeringInfoEntityMapper()) }
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(StoryFeedEntityMapper()) }
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(FriendEntityMapper()) }
        CoreDIContainer.shared.register(service: EndpointService.self) { URLSessionEndpointService.shared }
        CoreDIContainer.shared.register(service: DiskCacheStorage.self) { FileManagerDiskCacheStorage.shared }
        CoreDIContainer.shared.register(service: MemoryCacheStorage.self) { NSCacheMemoryCacheStorage.shared }
    }
    
    func registerSharedDependencies() {
        SharedDIContainer.shared.register(service: BundleResourceUseCase.self) { DefaultBundleResourceUseCase() }
        SharedDIContainer.shared.register(service: NicknameUseCase.self) { DefaultNicknameUseCase() }
        SharedDIContainer.shared.register(service: LoginTypeUseCase.self) { DefaultLoginTypeUseCase() }
        SharedDIContainer.shared.register(service: AutoLoginUseCase.self) { DefaultAutoLoginUseCase() }
        SharedDIContainer.shared.register(service: FeedVisibilityUseCase.self) { DefaultFeedVisibilityUseCase() }
        SharedDIContainer.shared.register(service: ProfileCharacterUseCase.self) { DefaultProfileCharacterUseCase() }
        SharedDIContainer.shared.register(service: StoryFeedUseCase.self) { DefaultStoryFeedUseCase() }
        SharedDIContainer.shared.register(service: StoryFeedRepository.self) { DefaultStoryFeedRepository() }
        SharedDIContainer.shared.register(service: StoolLogUseCase.self) { DefaultStoolLogUseCase() }
        SharedDIContainer.shared.register(service: StoolLogRepository.self) { DefaultStoolLogRepository() }
        SharedDIContainer.shared.register(service: CheeringInfoUseCase.self) { DefaultCheeringInfoUseCase() }
        SharedDIContainer.shared.register(service: CheeringInfoRepository.self) { DefaultCheeringInfoRepository() }
        SharedDIContainer.shared.register(service: BundleResourceRepository.self) { DefaultBundleResourceRepository() }
        SharedDIContainer.shared.register(service: UserDefaultsRepository.self) { DefaultUserDefaultsRepository() }
        SharedDIContainer.shared.register(service: KeyChainRepository.self) { DefaultKeyChainRepository() }
        SharedDIContainer.shared.register(service: UserInfoUseCase.self) { DefaultUserInfoUseCase() }
        SharedDIContainer.shared.register(service: UserInfoRepository.self) { DefaultUserInfoRepository() }
    }
    
    func registerLoginDependencies() {
        LoginDIContainer.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        LoginDIContainer.shared.register(service: SignupUseCase.self) { DefaultSignupUseCase() }
        LoginDIContainer.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
        LoginDIContainer.shared.register(service: SignupRepository.self) { DefaultSignupRepository() }
    }
    
    func registerHomeDependencies() {
        HomeDIContainer.shared.register(service: HomeUseCase.self) { DefaultHomeUseCase() }
        HomeDIContainer.shared.register(service: HomeRepository.self) { DefaultHomeRepository() }
    }
    
    func registerSettingDependencies() {
        SettingDIContainer.shared.register(service: UserSettingUseCase.self) { DefaultUserSettingUseCase() }
    }
    
    func registerReportDependencies() {
        ReportDIContainer.shared.register(service: ReportUseCase.self) { DefaultReportUseCase() }
    }
    
    func registerFriendListDependencies() {
        FriendListDIContainer.shared.register(service: FriendListUseCase.self) { DefaultFriendListUseCase() }
        FriendListDIContainer.shared.register(service: FriendListRepository.self) { DefaultFriendListRepository() }
    }
}

// MARK: - UI Setup

private extension SceneDelegate {
    func configureNavigationBarAppearance() {
        let emptyImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        UINavigationBar.appearance().backIndicatorImage = emptyImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = emptyImage
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
}

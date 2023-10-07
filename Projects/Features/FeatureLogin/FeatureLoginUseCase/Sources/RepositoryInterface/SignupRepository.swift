//
//  SignupRepository.swift
//  FeatureLoginUseCase
//
//  Created by Lee, Joon Woo on 2023/09/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxSwift

import CoreEntity
import Utils

public protocol SignupRepository: AnyObject {
    
    func requestSignup(with signupInput: SignupInput) -> Single<UserAuthInfoEntity>
}

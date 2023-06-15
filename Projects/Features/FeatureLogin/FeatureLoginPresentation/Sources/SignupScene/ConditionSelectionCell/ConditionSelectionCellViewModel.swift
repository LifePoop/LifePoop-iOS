//
//  ConditionSelectionCellViewModel.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import CoreEntity
import Utils

final class ConditionSelectionCellViewModel: ViewModelType {
  
    struct Input {
        let didTapCheckBox = PublishRelay<Void>()
        let didTapDetailButton = PublishRelay<Int>()
    }
    
    struct Output {
        let conditionDescription = BehaviorRelay<String>(value: "")
        let shouldHideDetailViewButton = BehaviorRelay<Bool>(value: true)
        let shouldSelectCheckBox = BehaviorRelay<Bool>(value: false)
    }

    let input = Input()
    let output = Output()
    let entity: AgreementCondition
        
    init(entity: AgreementCondition) {
        self.entity = entity
        output.conditionDescription.accept(entity.descriptionText)
        output.shouldHideDetailViewButton.accept(!entity.containsDetailView)
    }
}

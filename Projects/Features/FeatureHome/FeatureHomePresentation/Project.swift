//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Home, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package,
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Utils).dependency,
        .Project.module(.Features(.Home, .UseCase)).dependency,
        .Project.module(.Features(.Home, .DIContainer)).dependency,
        .SPM.SnapKit.dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxCocoa.dependency
    ]
)
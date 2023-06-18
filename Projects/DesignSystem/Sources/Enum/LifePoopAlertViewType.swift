//
//  LifePoopAlertViewType.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum LifePoopAlertViewType {
    case logout
    case withdraw
    case invitationCode
    
    public var title: String {
        switch self {
        case .logout:
            return "라이푸 서비스를\n로그아웃하시겠어요?"
        case .withdraw:
            return "라이푸 서비스를\n진짜 탈퇴하시겠어요?"
        case .invitationCode:
            return "초대 코드 입력하기"
        }
    }
    
    public var subTitle: String {
        switch self {
        case .logout:
            return "로그인 후 다시 나의 변 기록을 불러올 수 있어요 💩"
        case .withdraw:
            return "지금 탈퇴하면, 나의 변 기록이 전부 사라져요 🥲"
        case .invitationCode:
            return "친구에게 받은 초대 코드를 입력해주세요"
        }
    }
    
    public var cancelButtonTitle: String {
        return "취소"
    }
    
    public var confirmButtonTitle: String {
        switch self {
        case .logout:
            return "로그아웃하기"
        case .withdraw:
            return "탈퇴하기"
        case .invitationCode:
            return "입력 완료"
        }
    }
}

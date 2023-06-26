//
//  GenderType.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public enum GenderType: Int, CaseIterable, CustomStringConvertible {
    
    case female
    case male
    case etc
    
    public var description: String {
        switch self {
        case .female: return LocalizableString.female
        case .male: return LocalizableString.male
        case .etc: return LocalizableString.etc
        }
    }    
}

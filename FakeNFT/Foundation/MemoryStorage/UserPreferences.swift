//
//  UserPreferences.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 27.03.2025.
//

import Foundation

final class UserPreferences {
    private static let sortTypeKey = "selectedSortType"
    
    static var sortType: SortType {
        get {
            let savedValue = UserDefaults.standard.integer(forKey: sortTypeKey)
            return SortType(rawValue: savedValue) ?? .rating
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: sortTypeKey)
        }
    }
}

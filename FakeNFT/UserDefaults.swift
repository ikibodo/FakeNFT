//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 22.3.25..
//
import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let sortCriteriaKey = "selectedSortCriteria"

    func saveSortCriteria(_ criteria: SortCriteria) {
        UserDefaults.standard.set(criteria.rawValue, forKey: sortCriteriaKey)
    }

    func loadSortCriteria() -> SortCriteria {
        guard let savedCriteria = UserDefaults.standard.string(forKey: sortCriteriaKey),
              let criteria = SortCriteria(rawValue: savedCriteria) else {
            return .rating
        }
        return criteria
    }
}

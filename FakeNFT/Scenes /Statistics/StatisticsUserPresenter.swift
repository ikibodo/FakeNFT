//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 23.3.25..
//
import Foundation

protocol StatisticsUserViewProtocol: AnyObject {
    func updateUserInfo(_ user: StatisticsUser)
}

final class StatisticsUserPresenter {
    private weak var view: StatisticsUserViewProtocol?
    private let user: StatisticsUser
    
    init(user: StatisticsUser) {
        self.user = user
    }
    
    func attachView(_ view: StatisticsUserViewProtocol) {
        self.view = view
    }
    
    func loadUserData() {
        view?.updateUserInfo(user)
    }
    
    func getUserWebsite() -> String? {
        return user.website
    }
    
    func getUserId() -> String? {
        return user.id
    }
}

//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 25.3.25..
//
import Foundation

protocol StatisticsUserCollectionProtocol: AnyObject {
    func showError(_ message: String)
}

final class StatisticsUserCollectionPresenter {
    private weak var view: StatisticsUserCollectionProtocol?
    private var userId: String?
    
    init(userId: String?) {
        self.userId = userId
    }
    
    func attachView(_ view: StatisticsUserCollectionViewController) {
        self.view = view
    }
}

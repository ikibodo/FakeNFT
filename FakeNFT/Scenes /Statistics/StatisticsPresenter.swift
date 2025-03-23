//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by N L on 22.3.25..
//
import Foundation

protocol StatisticsViewProtocol: AnyObject {
    func showUsers(_ users: [StatisticsUser])
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class StatisticsPresenter {
    private weak var view: StatisticsViewProtocol?
    private let statisticsUserService: StatisticsUserService
    private var users: [StatisticsUser] = []
    private var currentSortCriteria: SortCriteria = .rating
    
    init(view: StatisticsViewProtocol, statisticsUserService: StatisticsUserService) {
        self.view = view
        self.statisticsUserService = statisticsUserService
    }
    
    func viewDidLoad() {
        loadUserStatistics()
    }
    
    func didSelectSorting(criteria: SortCriteria) {
        currentSortCriteria = criteria
        UserDefaultsManager.shared.saveSortCriteria(criteria)
        sortUsers()
    }
    
    func getUsersCount() -> Int {
        return users.count
    }

    func getUser(at index: Int) -> StatisticsUser? {
        guard index >= 0, index < users.count else { return nil }
        return users[index]
    }
    
    private func loadUserStatistics() {
        view?.showLoadingIndicator()
        
        statisticsUserService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoadingIndicator()
                
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.applySavedSorting()
                case .failure(let error):
                    self?.view?.showError("Ошибка загрузки пользователей: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func applySavedSorting() {
        currentSortCriteria = UserDefaultsManager.shared.loadSortCriteria()
        sortUsers()
    }
    
    private func sortUsers() {
        switch currentSortCriteria {
        case .name:
            users.sort {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                < $1.name.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        case .rating:
            users.sort {
                (Double($0.rating) ?? -Double.greatestFiniteMagnitude) <
// Так как в фигме нумерация идет сквозная от меньшего к большему, то сделала тут тот же принцип, хотя визуально это отличается от фигмы из-за того, какие данные приходят. Подробнее см комментарий к StatisticsCell.configure
                (Double($1.rating) ?? -Double.greatestFiniteMagnitude)
            }
        }
        view?.showUsers(users)
    }
}

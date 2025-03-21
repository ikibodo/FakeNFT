//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 18.03.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    func fetchUserProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    private weak var view: ProfileControllerProtocol?
    private let profileService: ProfileService

    // MARK: - Initializers
    init(view: ProfileControllerProtocol, profileService: ProfileService) {
        self.view = view
        self.profileService = profileService
    }

    // MARK: - Public Methods
    func fetchUserProfile() {
        profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    self.view?.displayProfileData(profile)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
}

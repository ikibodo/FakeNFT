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

class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    private weak var view: ProfileControllerProtocol?
    private let servicesAssembly: ServicesAssembly

    // MARK: - Initializers
    init(view: ProfileControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods
    func fetchUserProfile() {
        servicesAssembly.profileService.loadProfile { [weak self] result in
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

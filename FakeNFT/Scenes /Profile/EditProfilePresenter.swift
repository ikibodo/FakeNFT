//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 18.03.2025.
//

import Foundation

protocol EditProfilePresenterProtocol {
    func updateProfile(profile: UserProfile)
}

class EditProfilePresenter: EditProfilePresenterProtocol {
    // MARK: - Private Properties
    private weak var view: EditProfileControllerProtocol?
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initializers
    init(view: EditProfileControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Methods
    func updateProfile(profile: UserProfile) {
        
        servicesAssembly.profileService.updateProfile(profile: profile) { result in
            switch result {
            case .success(let updateProfile):
                self.view?.displayUpdatedProfileData(updateProfile)
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}



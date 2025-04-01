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

final class EditProfilePresenter {
    // MARK: - Private Properties
    private weak var view: EditProfileControllerProtocol?
    private let profileService: ProfileService
    
    // MARK: - Initializers
    init(view: EditProfileControllerProtocol, profileService: ProfileService) {
        self.view = view
        self.profileService = profileService
    }
}

// MARK: - EditProfilePresenterProtocol
extension EditProfilePresenter: EditProfilePresenterProtocol {
    func updateProfile(profile: UserProfile) {
        profileService.updateProfile(profile: profile) { result in
            switch result {
            case .success(let updateProfile):
                self.view?.displayUpdatedProfileData(updateProfile)
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}



//
//  MyNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit

final class MyNFT: UIViewController {
    
    // MARK: - Private Properties
    private lazy var backButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: boldConfig),
                                     style: .plain,
                                     target: self,
                                     action: #selector(modalCloseButtonTapped))
        button.tintColor = UIColor.black
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Profile.MyNFT.title", comment: "")
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        dismiss(animated: true)
    }
}

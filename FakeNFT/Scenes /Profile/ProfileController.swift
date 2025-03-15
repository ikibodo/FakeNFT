//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import UIKit

final class ProfileController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mockUserProfile = UserProfile(name: "Студентус Практикумус",
                                          avatar: "mock_avatar",
                                          description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                                          website: "https://practicum.yandex.ru/ios-developer",
                                          nfts: ["68","69","71","72","73","74","75","76","77","78","79","80","81"],
                                          likes: ["5","13","19","26","27","33","35","39","41","47","56","66"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}

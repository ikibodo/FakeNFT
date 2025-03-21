import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: "Каталог"),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: "Профиль"),
        image: UIImage(systemName: "person.circle.fill"),
        
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let profileController = ProfileController(servicesAssembly: servicesAssembly)
        let profilePresenter = ProfilePresenter(
            view: profileController,
            profileService: servicesAssembly.profileService
        )
        profileController.setPresenter(presenter: profilePresenter)
        profileController.tabBarItem = profileTabBarItem
        
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [
            UINavigationController(rootViewController: profileController),
            catalogController
        ]
    }
}

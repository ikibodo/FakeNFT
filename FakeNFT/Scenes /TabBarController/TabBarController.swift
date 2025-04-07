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
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: "Статистика"),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: "Корзина"),
        image: UIImage(named: "cart"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = .segmentActive
        view.backgroundColor = .systemBackground
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        statisticsController.tabBarItem = statisticsTabBarItem
        let statisticsNavController = UINavigationController(rootViewController: statisticsController)
        
        let profileController = ProfileController(servicesAssembly: servicesAssembly)
        let profilePresenter = ProfilePresenter(
            view: profileController,
            profileService: servicesAssembly.profileService
        )
        profileController.setPresenter(presenter: profilePresenter)
        profileController.tabBarItem = profileTabBarItem
        
//        let cartController = CartViewController(
//            servicesAssembly: servicesAssembly
//        )
//        cartController.tabBarItem = cartTabBarItem
        
        viewControllers = [
            UINavigationController(rootViewController: profileController),
            catalogController,
            statisticsNavController,
//            cartController
        ]
    }
}

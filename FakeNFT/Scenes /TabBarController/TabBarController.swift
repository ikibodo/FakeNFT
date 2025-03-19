import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: CartViewController
        let cartViewController = CartViewController()
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)
        cartNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(named: "cart"),
            selectedImage: nil
        )
        // MARK: ProfileViewController
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil
        )
        // MARK: CatalogViewController
        let catalogViewController = CatalogViewController()
        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "rectangle.stack.fill"),
            selectedImage: nil
        )
        // MARK: StatisticViewController
        let statisticViewController = StatiscticsViewController()
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            image: UIImage(systemName: "flag.2.crossed.fill"),
            selectedImage: nil
        )
        self.viewControllers = [
            profileNavigationController,
            catalogNavigationController,
            cartNavigationController,
            statisticNavigationController
        ]
        tabBar.unselectedItemTintColor = UIColor(named: "blackDayNight")
        view.backgroundColor = UIColor(named: "whiteDayNight")
    }
}

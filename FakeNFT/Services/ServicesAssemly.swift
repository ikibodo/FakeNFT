final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImp(
            networkClient: networkClient,
            storage: profileStorage)
    }
    
    var statisticsUserService: StatisticsUserService {
        StatisticsUserService(networkClient: networkClient)
    }
}

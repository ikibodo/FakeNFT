import Foundation

struct CartGetNftsRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    
    init(nftId: String) {
        guard let endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)") else {
            self.endpoint = nil
            self.httpMethod = .get
            self.dto = nil
            return
        }
        self.endpoint = endpoint
        self.httpMethod = .get
        self.dto = nil
    }
}

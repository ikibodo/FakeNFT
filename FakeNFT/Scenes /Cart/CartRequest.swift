import Foundation

struct CartRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    
    init() {
        guard let endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else {
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

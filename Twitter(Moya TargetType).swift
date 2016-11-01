import Moya

enum Twitter: TargetType {
    case home(maxID: Int?)
    case user
    case tweet(body: String)
}
extension Twitter {
    
    var baseURL: URL { return URL(string: "https://api.twitter.com/1.1")! }
    
    var path: String {
        switch self {
        case .home: return "/statuses/home_timeline.json"
        case .user: return "/account/verify_credentials.json"
        case .tweet: return "/statuses/update.json"
        }
    }
    var method: Method {
        switch self {
        case .tweet: return .POST
        default: return .GET
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .home(let maxID):
            var dict = [String:Any]()
            dict["count"] = 20
            if let maxID = maxID {
                dict["max_id"] = maxID
            }
            return dict
        case .user:
            return nil
        case .tweet(body: let body):
            return ["status":body.urlEscaped]
        }
    }
    var sampleData: Data { return Data() }
    var task: Task { return .request}
}

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

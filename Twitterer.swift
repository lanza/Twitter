import OAuthSwift
import OAuthSwiftAlamofire
import Alamofire
import Moya
import SwiftyJSON
import Prephirences
import RxSwift

class Twitterer {
    static var user: User!
    
    static var timeline = Variable([Tweet]())
   
    static var provider: MoyaProvider<Twitter>!
    static let isAuthed = Variable(false)
    static let isLoadingMoreData = Variable(false)
    
    static let oauthConsumerKey = "R8IkjsyifH87HxO185lNoIybB"
    static let oauthConsumerSecret = "xgg6CIGy42oda5fuPwk9BK2N1O32q3eHLb1T6udPwBCblSI3MI"
    static let baseURL = "https://api.twitter.com"
    static var oauthURL: String { return baseURL + "/oauth" }
    static var requestTokenURL: String { return oauthURL + "/request_token" }
    static var authorizeURL: String { return oauthURL + "/authorize" }
    static var accessTokenURL: String { return oauthURL + "/access_token" }

    static var callbackURL: String { return "oauth-swift://oauth-callback/twitter" }

    static let oAuthSwift = OAuth1Swift(consumerKey: oauthConsumerKey, consumerSecret: oauthConsumerSecret, requestTokenUrl: requestTokenURL, authorizeUrl: authorizeURL, accessTokenUrl: accessTokenURL)
    
    static func didAuth() {
        let sessionManager = SessionManager.default
        sessionManager.adapter = oAuthSwift.requestAdapter
        let requestClosure = { (endpoint: Endpoint<Twitter>, done: MoyaProvider.RequestResultClosure) in
            var request = endpoint.urlRequest!
            
            var headers = request.allHTTPHeaderFields!
            headers["Content-Type"] = nil
            request.allHTTPHeaderFields = headers
            
            done(.success(request))
        }
        provider = MoyaProvider<Twitter>(requestClosure: requestClosure, manager: sessionManager)
        isAuthed.value = true
    }
    
    static func auth() {
        let defaults = UserDefaults.standard
        if let token = defaults["token"] as? String, let secret = defaults["secret"] as? String {
            oAuthSwift.client.credential.oauthToken = token
            oAuthSwift.client.credential.oauthTokenSecret = secret
            didAuth()
        } else {
            isLoadingMoreData.value = true
            let success: OAuthSwift.TokenSuccessHandler = { credential, response, parameters in
                didAuth()
                let dict = ["token":oAuthSwift.client.credential.oauthToken,"secret":oAuthSwift.client.credential.oauthTokenSecret]
                defaults.set(dictionary: dict)
                self.isLoadingMoreData.value = false
            }
            let failure: OAuthSwift.FailureHandler = { error in
                print(error)
                self.isLoadingMoreData.value = false
            }
            oAuthSwift.authorize(withCallbackURL: callbackURL, success: success, failure: failure)
        }
    }
    
    static func getUser() {
        provider.request(.user) { result in
            switch result {
            case .failure(let error):
                print(error)
                fatalError()
            case .success(let response):
                User.active = User(json: JSON(data: response.data))
            }
        }
    }
    enum Timeline {
        case page
        case refresh
    }
    
    static func get(timeline: Timeline) {
        self.isLoadingMoreData.value = true
        provider.request(.home(maxID: nil)) { result in
            self.isLoadingMoreData.value = false
            switch result {
            case .success(let response):
                let tweets = JSON(data: response.data).arrayValue.map { Tweet(json: $0) }
                switch timeline {
                case .refresh:
                    self.timeline.value = tweets
                case .page:
                    self.timeline.value += tweets
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    static func post(tweet: String) {
        
//        provider.request(.tweet(body: tweet)) { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let response):
//                dump(response.request!)
//                print(String(data: response.data, encoding: .utf8)!)
//            }
//        }
        
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        let params = ["status":tweet.urlEscaped]
        
//        let sessionManager = SessionManager.default
//        sessionManager.adapter = oAuthSwift.requestAdapter
//        sessionManager.request(url, method: .post, parameters: params, headers: nil).responseJSON { response in
//            dump(response.request!)
//            print(String(data: response.data!,encoding: .utf8)!)
//        }
        oAuthSwift.client.post(url, parameters: params, headers: nil, success: { result in
            dump(result.1)
            print(String(data: result.0, encoding: .utf8)!)
        }, failure: nil)
        
    }
    
    static func post(reply: String, to tweet: Tweet) {
        oAuthSwift.client.post("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status":reply.urlEscaped,"in_reply_to_status_id":tweet.id], success: nil, failure: nil)
    }
    
    static func post(retweet: Tweet) {
        oAuthSwift.client.post("https://api.twitter.com/1.1/statuses/retweet/\(retweet.id).json", parameters: ["id":retweet.id], success: { thing in
            print(String(data: thing.0, encoding: .utf8)!)
            dump(thing.1)
            
        }, failure: nil)
    }
    
    static func post(favorite tweet: Tweet) {
        oAuthSwift.client.post("https://api.twitter.com/1.1/favorites/create.json", parameters: ["id":tweet.id], success: nil, failure: nil)
    }
}







































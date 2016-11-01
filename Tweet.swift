import SwiftyJSON
import Foundation

struct Tweet {
    init(json: JSON) {
        tweeter = json["user"]["name"].stringValue
        text = json["text"].stringValue
        retweetCount = json["retweet_count"].stringValue
        retweeted = json["retweeted"].boolValue
        profileImageURL = json["user"]["profile_image_url"].stringValue
        source = json["user"]["screen_name"].stringValue
        timeTweeted = json["created_at"].stringValue
        id = json["id"].stringValue
    }
    var source: String
    var profileImageURL: String
    var tweeter: String
    var text: String
    var retweetCount: String
    var retweeted: Bool
    var timeTweeted: String
    var id: String
}

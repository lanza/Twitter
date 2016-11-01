import Foundation
import SwiftyJSON

struct User {
    
    init(json: JSON) {
        name = json["name"].stringValue
        handle = json["screen_name"].stringValue
        profileImageURL = json["profile_image_url_https"].stringValue
    }
    
    static var active: User?
    
    var profileImageURL: String 
    var name: String
    var handle: String
    
}

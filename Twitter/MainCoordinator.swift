import CoordinatorKit
import RxSwift
import RxCocoa
import SwiftyJSON
import AlamofireImage

class MainCoordinator: NavigationCoordinator {
    override init() {
        let tc = TweetsCoordinator()
        tc.start()
        super.init(rootCoordinator: tc)
    }
    override func start() {
        super.start()
        Twitterer.auth()
        Twitterer.isAuthed.asObservable().subscribe(onNext: { value in
            if value {
                Twitterer.getUser()
            }
        }).addDisposableTo(db)
    }
    
    let db = DisposeBag()
}











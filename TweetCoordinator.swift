import UIKit
import CoordinatorKit
import RxCocoa
import RxSwift

class TweetCoordinator: Coordinator {
    
    var tweet: Tweet!
    
    var tweetVC: TweetVC { return viewController as! TweetVC }
    
    override func start() {
        super.start()
        
        viewController = TweetVC()
        tweetVC.tweet = tweet
        print(tweetVC.view)
        tweetVC.tweetView.replyButton.rx.tap.subscribe(onNext: {
            self.startReplyCoordinator()
        }).addDisposableTo(db)
    }
    
    func startReplyCoordinator() {
        let rc = ReplyCoordinator()
        rc.tweet = tweet
        rc.start()
        rc.didSubmit = {
            print(self.navigationCoordinator!.coordinators)
            _ = self.navigationCoordinator?.popCoordinator(animated: true)
        }
        show(rc, sender: self)
    }
    
    let db = DisposeBag()
}

class ReplyCoordinator: Coordinator {
    var tweet: Tweet!
    var composeVC: ComposeVC { return viewController as! ComposeVC }
    
    override func start() {
        super.start()
        viewController = ComposeVC()
        composeVC.setupNavigationBar()
        composeVC.navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: {
            let body = self.composeVC.tweetTextView.text!
            Twitterer.post(reply: body, to: self.tweet)
            self.didSubmit()
        }).addDisposableTo(db)
    }
    
    var didSubmit: (()->())!
    
    let db = DisposeBag()
}


class TweetVC: UIViewController {
    var tweet: Tweet!
    
    var tweetView: TweetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tweetView = Bundle.main.loadNibNamed("TweetView", owner: self, options: nil)!.first! as! TweetView
        
        view.addSubview(tweetView)
        tweetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tweetView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            tweetView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tweetView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
        
        tweetView.profileImageView.af_setImage(withURL: URL(string: tweet.profileImageURL)!)
        tweetView.nameLabel.text = tweet.tweeter
        tweetView.handleLabel.text = tweet.source
        tweetView.dateLabel.text = tweet.timeTweeted
        tweetView.textLabel.text = tweet.text
        
        tweetView.retweetButton.rx.tap.subscribe(onNext: {
            Twitterer.post(retweet: self.tweet)
        }).addDisposableTo(db)
        tweetView.starButton.rx.tap.subscribe(onNext: {
            self.tweetView.starButton.setTitle("Favorited", for: UIControlState())
            Twitterer.post(favorite: self.tweet)
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
}

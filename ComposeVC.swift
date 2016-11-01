import RxSwift
import UIKit

class ComposeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    let nameLabel = UILabel()
    let handleLabel = UILabel()
    let tweetTextView = UITextView()
    let profileImageView = UIImageView()
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .done, target: nil, action: nil)
    }
    func setupViews() {
        [nameLabel,handleLabel,tweetTextView,profileImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            super.view.addSubview(view)
        }
        
        nameLabel.text = User.active!.name
        handleLabel.text = User.active!.handle
        profileImageView.af_setImage(withURL: URL(string: User.active!.profileImageURL)!)
        
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            profileImageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor),
            nameLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            handleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor),
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            handleLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            nameLabel.heightAnchor.constraint(equalTo: handleLabel.heightAnchor),
            tweetTextView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            tweetTextView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            tweetTextView.topAnchor.constraint(equalTo: handleLabel.bottomAnchor),
            tweetTextView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
        
    }
    let db = DisposeBag()
}

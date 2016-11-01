import UIKit

class TweetCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        replyButton.setTitle("Reply", for: UIControlState())
        replyButton.setTitleColor(.black, for: UIControlState())
        retweetButton.setTitle("Retweet", for: UIControlState())
        retweetButton.setTitleColor(.black, for: UIControlState())
        starButton.setTitle("Star", for: UIControlState())
        starButton.setTitleColor(.black, for: UIControlState())
        setupConstraints()
    }
    func setupConstraints() {
        let buttonsSV = UIStackView(arrangedSubviews: [replyButton,retweetButton,starButton])
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually
        [buttonsSV, tweetLabel, tweeterNameLabel, tweenerAccountLabel, hoursAgoLabel, profileImageView, retweetedLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        var constraints = [NSLayoutConstraint]()
        constraints.append(retweetedLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor))
        constraints.append(retweetedLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor))
        constraints.append(retweetedLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor))
        constraints.append(profileImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor))
        constraints.append(profileImageView.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor))
        constraints.append(profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor))
        constraints.append(profileImageView.heightAnchor.constraint(equalToConstant: 50))
        //        constraints.append(profileImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor))
        constraints.append(tweeterNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor))
        constraints.append(tweeterNameLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor))
        //        tweeterNameLabel.setContentHuggingPriority(1000, for: .horizontal)
        //        tweeterNameLabel.setContentHuggingPriority(1000, for: .vertical)
        //        retweetedLabel.setContentHuggingPriority(1000, for: .vertical)
        //        retweetedLabel.setContentHuggingPriority(500, for: .horizontal)
        //        retweetedLabel.setContentCompressionResistancePriority(500, for: .horizontal)
        constraints.append(tweenerAccountLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor))
        constraints.append(tweenerAccountLabel.leftAnchor.constraint(equalTo: tweeterNameLabel.rightAnchor))
        //        hoursAgoLabel.setContentHuggingPriority(1000, for: .horizontal)
        //        hoursAgoLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
        constraints.append(tweenerAccountLabel.rightAnchor.constraint(equalTo: hoursAgoLabel.leftAnchor))
        constraints.append(hoursAgoLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor))
        constraints.append(hoursAgoLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor))
        
        constraints.append(tweetLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor))
        constraints.append(tweetLabel.topAnchor.constraint(equalTo: tweeterNameLabel.bottomAnchor))
        constraints.append(tweetLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor))
        tweetLabel.numberOfLines = 0
        //        constraints.append(tweetLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor))
        constraints.append(buttonsSV.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor))
        constraints.append(buttonsSV.leftAnchor.constraint(equalTo: tweetLabel.leftAnchor))
        constraints.append(buttonsSV.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor))
        //        buttonsSV.setContentHuggingPriority(1000, for: .vertical)
        
        NSLayoutConstraint.activate(constraints)
        
    }
    let tweetLabel = UILabel()
    let retweetedLabel = UILabel()
    let tweeterNameLabel = UILabel()
    let tweenerAccountLabel = UILabel()
    let profileImageView = UIImageView()
    let replyButton = UIButton()
    let retweetButton = UIButton()
    let starButton = UIButton()
    let hoursAgoLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(for tweet: Tweet) {
        tweetLabel.text = tweet.text
        tweeterNameLabel.text = tweet.tweeter
        tweenerAccountLabel.text = "@" + tweet.source
        if tweet.retweeted {
            retweetedLabel.text = "HI"
        }
        
        var strings = tweet.timeTweeted.components(separatedBy: " ")
        strings.remove(at: 0)
        strings.remove(at: 3)
        strings.remove(at: 3)
        
        hoursAgoLabel.text = strings.joined(separator: " ")
        profileImageView.af_setImage(withURL: URL(string: tweet.profileImageURL)!)
    }
    
}

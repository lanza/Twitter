import UIKit
import RxSwift
import RxCocoa

class TweetsTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRx()
        setupRefreshControl()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: nil, action: nil)
    }
    
    func setupRx() {
        Twitterer.isAuthed.asObservable().subscribe(onNext: { value in
            if value {
                Twitterer.get(timeline: .refresh)
            }
        }).addDisposableTo(db)
        Twitterer.timeline.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: TweetCell.self)) { row, tweet, cell in
            cell.configure(for: tweet)
        }.addDisposableTo(db)
        Twitterer.isLoadingMoreData.asObservable().subscribe(onNext: { value in
            if value {
                self.refreshControl?.beginRefreshing()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
    
    func setupTableView() {
        tableView.register(TweetCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.insertSubview(refreshControl!, at: 0)
        
        refreshControl?.rx.controlEvent(.valueChanged).asObservable().subscribe(onNext: { _ in
            self.refreshControl?.beginRefreshing()
            Twitterer.get(timeline: .refresh)
        }).addDisposableTo(db)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Twitterer.timeline.value.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        cell.configure(for: Twitterer.timeline.value[indexPath.row])
        return cell
    }
}

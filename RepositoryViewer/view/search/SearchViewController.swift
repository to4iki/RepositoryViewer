import UIKit
import RxSwift
import RxCocoa
import GitHubAPI

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: PaginationViewModel<Repository>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GitHubAPI.SearchRepositoriesRequest(query: "Swift")
        viewModel = PaginationViewModel(
            request: request,
            viewWillAppear: rx.viewWillAppear.asDriver(),
            scrollViewDidReachBottom: tableView.rx.reachedBottom.asDriver()
        )
        bind()
    }
    
    private func bind() {
        disposeBag.bulkInsert([
            viewModel.elements.drive(tableView.rx.items(cellIdentifier: "RepositoryCell")) { (row, element, cell) in
                cell.textLabel?.text = element.fullName
            },
            viewModel.isLoading.map({ !$0 }).drive(indicatorView.rx.isHidden),
            viewModel.error.drive(onNext: { print($0) })
        ])
    }
}

import UIKit
import RxSwift
import RxCocoa
import GitHubAPI

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: SearchViewModel<Repository>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nonEmptyQuery = searchBar.rx.text.orEmpty.asDriver()
            .skip(1)
            .debounce(0.3)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
        
        viewModel = SearchViewModel(
            requestType: GitHubAPI.SearchRepositoriesRequest.self,
            query: nonEmptyQuery,
            scrollViewDidReachBottom: tableView.rx.reachedBottom.asDriver()
        )
        
        bind()
    }
    
    private func bind() {
        Observable.merge(searchBar.rx.searchButtonClicked.asObservable(), searchBar.rx.cancelButtonClicked.asObservable())
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.searchBar.showsCancelButton = false
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.searchBar.showsCancelButton = true
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(tableView.rx.items(cellIdentifier: "RepositoryCell")) { (row, element, cell) in
                cell.textLabel?.text = element.fullName
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map({ !$0 })
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}

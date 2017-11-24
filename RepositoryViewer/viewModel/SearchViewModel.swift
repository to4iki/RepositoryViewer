import APIKit
import RxSwift
import RxCocoa
import Action
import GitHubAPI

final class SearchViewModel<Element: Decodable> {
    let elements: Driver<[Element]>
    let error: Driver<Error>
    let isLoading: Driver<Bool>
    private let disposeBag = DisposeBag()
    
    init<Request: SearchRequest>(
        session: Session = Session.shared,
        requestType: Request.Type,
        query: Driver<String>,
        scrollViewDidReachBottom: Driver<Void>) where Request.Response.Element == Element {
        
        let action: Action<Request, AnyPaginationResponse<Element>> = Action { (request: Request) -> Observable<AnyPaginationResponse<Element>> in
            session.rx.send(request).asObservable().map(AnyPaginationResponse.init)
        }
        
        elements = Driver.combineLatest(query, action.elements.asDriver(onErrorDriveWith: .empty()))
            .scan([]) { (acc: [Element], result: (query: String, response: AnyPaginationResponse<Element>)) -> [Element] in
                if (result.response.page == 1) || (result.query != result.response.query) {
                    return result.response.elements
                } else {
                    return acc + result.response.elements
                }
            }
            .startWith([])
        
        error = action.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
        
        isLoading = action.executing.asDriver(onErrorJustReturn: false)
        
        scrollViewDidReachBottom.asObservable()
            .withLatestFrom(action.elements)
            .flatMap { element -> Observable<Request> in
                if let nextPage = element.nextPage {
                    return Observable.of(Request(query: element.query, page: nextPage))
                } else {
                    return Observable.empty()
                }
            }
            .subscribe(action.inputs)
            .disposed(by: disposeBag)
        
        query
            .map { Request(query: $0, page: 0) }
            .drive(action.inputs)
            .disposed(by: disposeBag)
    }
}

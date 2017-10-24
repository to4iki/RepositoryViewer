import APIKit
import RxSwift
import RxCocoa
import Action
import GitHubAPI

final class PaginationViewModel<Element: Decodable> {
    let elements: Driver<[Element]>
    let error: Driver<Error>
    let isLoading: Driver<Bool>
    
    private let disposeBag = DisposeBag()
    
    init<Request: PaginationRequest>(
        session: Session = Session.shared,
        request: Request,
        viewWillAppear: Driver<Void>,
        scrollViewDidReachBottom: Driver<Void>) where Request.Response.Element == Element {
        
        let action: Action<Int, AnyPaginationResponse<Element>> = Action { (page: Int) -> Observable<AnyPaginationResponse<Element>> in
            var _request = request
            _request.page = page
            return session.rx.send(_request).asObservable().map(AnyPaginationResponse.init)
        }

        elements = action.elements.asDriver(onErrorDriveWith: .empty())
            .scan([]) { (acc: [Element], response: AnyPaginationResponse<Element>) -> [Element] in
                response.page == 1 ? response.elements : acc + response.elements
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
        
        viewWillAppear.asObservable()
            .map { _ in 1 }
            .subscribe(action.inputs)
            .disposed(by: disposeBag)
        
        scrollViewDidReachBottom.asObservable()
            .withLatestFrom(action.elements)
            .flatMap { $0.nextPage.map { Observable.of($0) } ?? Observable.empty() }
            .subscribe(action.inputs)
            .disposed(by: disposeBag)
    }
}

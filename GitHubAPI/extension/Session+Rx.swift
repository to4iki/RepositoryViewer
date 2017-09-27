import APIKit
import RxSwift

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    public static func send<T: Request>(_ request: T) -> Single<T.Response> {
        return Single<T.Response>.create { observer in
            let task = Session.send(request, callbackQueue: .main) { result in
                switch result {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

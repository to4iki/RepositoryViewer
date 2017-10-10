import RxSwift

extension DisposeBag {
    func bulkInsert(_ disposables: [Disposable]) {
        disposables.forEach(insert)
    }
}

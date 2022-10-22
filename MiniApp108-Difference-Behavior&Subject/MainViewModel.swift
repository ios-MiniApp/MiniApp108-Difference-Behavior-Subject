//
//  MainViewModel.swift
//  MiniApp108-Difference-Behavior&Subject
//
//  Created by 前田航汰 on 2022/10/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay

// MARK: - Protocol
// MARK: Inputs
public protocol MainViewModelInputs {
    var subscribeButtonObservable: Observable<Void> { get }
    var segmentedIndexObservable: Observable<Int> { get }
}

// MARK: Outputs
public protocol MainViewModelOutputs {
    var outputNumberBehaviorRelay: BehaviorRelay<Int> { get }
    var outputNumberPublishRelay: PublishRelay<Int> { get }
}

// MARK: InputOutputType
public protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}


class MainViewModel: MainViewModelInputs, MainViewModelOutputs, MainViewModelType {

    // MARK: Inputs
    internal var subscribeButtonObservable: Observable<Void>
    internal var segmentedIndexObservable: Observable<Int>

    // MARK: Outputs
    public var outputNumberBehaviorRelay = BehaviorRelay<Int>(value: 0)
    public var outputNumberPublishRelay = PublishRelay<Int>()

    // MARK: InputOutputType
    public var inputs: MainViewModelInputs { return self }
    public var outputs: MainViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let disposeBag = DisposeBag()
    private var number = 0

    // MARK: - Initialize
    init(
        subscribeButtonObservable: Observable<Void>,
        segmentedIndexObservable: Observable<Int>
    ) {
        self.subscribeButtonObservable = subscribeButtonObservable
        self.segmentedIndexObservable = segmentedIndexObservable

        setupBindings()
    }

    private func setupBindings() {
        segmentedIndexObservable.asObservable()
            .subscribe(onNext: { [weak self] index in
                self?.number = index
                print(index)
            }).disposed(by: disposeBag)

        subscribeButtonObservable.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.outputNumberPublishRelay
                    .accept(self?.number ?? 0)
                self?.outputNumberBehaviorRelay
                    .accept(self?.number ?? 0)
            }).disposed(by: disposeBag)
    }

}

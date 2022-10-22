//
//  ViewController.swift
//  MiniApp108-Difference-Behavior&Subject
//
//  Created by 前田航汰 on 2022/10/22.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class ViewController: UIViewController {

    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var subscribeButton: UIButton!
    @IBOutlet private weak var behaviorRelayLabel: UILabel!
    @IBOutlet private weak var publishRelayLabel: UILabel!

    private let disposeBag = DisposeBag()
    private var mainViewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewModel = MainViewModel(
            subscribeButtonObservable: subscribeButton.rx.tap.asObservable(),
            segmentedIndexObservable: segmentedController.rx.selectedSegmentIndex.asObservable()
        )

    }

    @IBAction private func didTapSubscribeButton(_ sender: Any) {
        mainViewModel!.outputs.outputNumberBehaviorRelay
            .subscribe{ [weak self] number in
                self?.behaviorRelayLabel.text = String(number)
                print("behaviorRelay", number)
            }.disposed(by: disposeBag)

        mainViewModel!.outputs.outputNumberPublishRelay
            .subscribe{ [weak self] number in
                self?.publishRelayLabel.text = String(number)
                print("publishRelay", number)
            }.disposed(by: disposeBag)
    }

}


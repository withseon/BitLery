//
//  DialogViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation
import RxCocoa
import RxSwift

final class DialogViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    private let monitor = NetworkMonitorService.shared
    
    deinit {
        print("✨Dialog VM deinit")
    }
    
    struct Input {
        let confirmButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let dismissTrigger: PublishRelay<Void>
        let actionTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let dismissTrigger = PublishRelay<Void>()
        let actionTrigger = PublishRelay<Void>()
        
        input.confirmButtonTapped
            .bind(with: self) { owner, _ in
                if owner.monitor.isConnected {
                    dismissTrigger.accept(())
                } else {
                    actionTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(dismissTrigger: dismissTrigger,
                      actionTrigger: actionTrigger)
    }

}

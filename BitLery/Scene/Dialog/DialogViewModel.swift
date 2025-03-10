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
    
    deinit {
        print("✨Dialog VM deinit")
    }
    
    struct Input {
        let confirmButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let dismissTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let dismissTrigger = PublishRelay<Void>()
        
        input.confirmButtonTapped
            .bind { _ in
                dismissTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(dismissTrigger: dismissTrigger)
    }

}

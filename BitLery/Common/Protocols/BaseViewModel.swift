//
//  BaseViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    var disposeBag: DisposeBag { get }
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

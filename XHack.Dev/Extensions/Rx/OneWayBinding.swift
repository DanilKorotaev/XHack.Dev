//
//  OnewWayBinding.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <-

func <-<T: Comparable>(property: ControlProperty<T>, variable: BehaviorSubject<T>) -> Disposable {
    return variable.asObservable()
        .distinctUntilChanged()
        .bind(to: property)
}

func <-<T: Comparable>(left: BehaviorSubject<T>, right: BehaviorSubject<T>) -> Disposable {
    return right.asObservable()
        .distinctUntilChanged()
        .bind(to: left)
}

func <-<T: Comparable>(left: PublishSubject<T>, right: ControlEvent<T>) -> Disposable {
    return right.asObservable()
        .distinctUntilChanged()
        .bind(to: left)
}

func <-<T>(left: PublishSubject<T>, right: ControlEvent<T>) -> Disposable {
    return right.asObservable()
        .bind(to: left)
}

func <-(left: PublishSubject<Void>, right: ControlEvent<Void>) -> Disposable {
    return right.asObservable()
        .bind(to: left)
}


func <-<T>(left: Binder<T>, right: BehaviorSubject<T>) -> Disposable {
    return right.bind(to: left)
}

func <-<T>(left: Binder<T?>, right: BehaviorSubject<T>) -> Disposable {
    return right.bind(to: left)
}

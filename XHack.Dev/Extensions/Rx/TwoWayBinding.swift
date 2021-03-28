//
//  TwoWayBinding.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

func <-><T: Comparable>(property: ControlProperty<T>, variable: BehaviorSubject<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .distinctUntilChanged()
        .bind(to: property)

    let propertyToVariable = property
        .distinctUntilChanged()
        .bind(to: variable)

    return CompositeDisposable.init(variableToProperty, propertyToVariable)
}


func <-><T>(property: ControlProperty<T>, variable: BehaviorSubject<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .bind(to: variable)

    return CompositeDisposable.init(variableToProperty, propertyToVariable)
}


func <-><T: Comparable>(left: BehaviorSubject<T>, right: BehaviorSubject<T>) -> Disposable {
    let leftToRight = left.asObservable()
        .distinctUntilChanged()
        .bind(to: right)

    let rightToLeft = right.asObservable()
        .distinctUntilChanged()
        .bind(to: left)

    return CompositeDisposable.init(leftToRight, rightToLeft)
}

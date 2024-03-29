//
//  ObservableArray.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

public struct ArrayChangeEvent {
    public let insertedIndices: [Int]
    public let deletedIndices: [Int]
    public let updatedIndices: [Int]

    fileprivate init(inserted: [Int] = [], deleted: [Int] = [], updated: [Int] = []) {
        assert(inserted.count + deleted.count + updated.count > 0)
        insertedIndices = inserted
        deletedIndices = deleted
        updatedIndices = updated
    }
}

public struct ObservableArray<Element>: ExpressibleByArrayLiteral {
    public typealias EventType = ArrayChangeEvent

    internal var eventSubject: PublishSubject<EventType>!
    internal var elementsSubject: BehaviorSubject<[Element]>!
    internal var elements: [Element]

    public init() {
        elements = []
    }

    public init(count: Int, repeatedValue: Element) {
        elements = Array(repeating: repeatedValue, count: count)
    }

    public init<S : Sequence>(_ s: S) where S.Iterator.Element == Element {
        elements = Array(s)
    }

    public init(arrayLiteral elements: Element...) {
        self.elements = elements
    }
}

extension ObservableArray {
    public mutating func rx_elements() -> Observable<[Element]> {
        if elementsSubject == nil {
            elementsSubject = BehaviorSubject<[Element]>(value: elements)
        }
        return elementsSubject
    }

    public mutating func rx_events() -> Observable<EventType> {
        if eventSubject == nil {
            eventSubject = PublishSubject<EventType>()
        }
        return eventSubject
    }

    fileprivate func arrayDidChange(_ event: EventType) {
        elementsSubject?.onNext(elements)
        eventSubject?.onNext(event)
    }
}

extension ObservableArray: Collection {
    public var capacity: Int {
        return elements.capacity
    }

    /*public var count: Int {
        return elements.count
    }*/

    public var startIndex: Int {
        return elements.startIndex
    }

    public var endIndex: Int {
        return elements.endIndex
    }

    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
}

extension ObservableArray: MutableCollection {
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        elements.reserveCapacity(minimumCapacity)
    }

    public mutating func append(_ newElement: Element) {
        elements.append(newElement)
        arrayDidChange(ArrayChangeEvent(inserted: [elements.count - 1]))
    }

    public mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element {
        let end = elements.count
        elements.append(contentsOf: newElements)
        guard end != elements.count else {
            return
        }
        arrayDidChange(ArrayChangeEvent(inserted: Array(end..<elements.count)))
    }

    public mutating func appendContentsOf<C : Collection>(_ newElements: C) where C.Iterator.Element == Element {
        guard !newElements.isEmpty else {
            return
        }
        let end = elements.count
        elements.append(contentsOf: newElements)
        arrayDidChange(ArrayChangeEvent(inserted: Array(end..<elements.count)))
    }

    @discardableResult public mutating func removeLast() -> Element {
        let e = elements.removeLast()
        arrayDidChange(ArrayChangeEvent(deleted: [elements.count]))
        return e
    }

    public mutating func insert(_ newElement: Element, at i: Int) {
        elements.insert(newElement, at: i)
        arrayDidChange(ArrayChangeEvent(inserted: [i]))
    }

    @discardableResult public mutating func remove(at index: Int) -> Element {
        let e = elements.remove(at: index)
        arrayDidChange(ArrayChangeEvent(deleted: [index]))
        return e
    }

    public mutating func removeAll(_ keepCapacity: Bool = false) {
        guard !elements.isEmpty else {
            return
        }
        let es = elements
        elements.removeAll(keepingCapacity: keepCapacity)
        arrayDidChange(ArrayChangeEvent(deleted: Array(0..<es.count)))
    }

    public mutating func insertContentsOf(_ newElements: [Element], atIndex i: Int) {
        guard !newElements.isEmpty else {
            return
        }
        elements.insert(contentsOf: newElements, at: i)
        arrayDidChange(ArrayChangeEvent(inserted: Array(i..<i + newElements.count)))
    }

    public mutating func popLast() -> Element? {
        let e = elements.popLast()
        if e != nil {
            arrayDidChange(ArrayChangeEvent(deleted: [elements.count]))
        }
        return e
    }
}

extension ObservableArray: RangeReplaceableCollection {
    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newCollection: C) where C.Iterator.Element == Element {
        let oldCount = elements.count
        elements.replaceSubrange(subRange, with: newCollection)
        let first = subRange.lowerBound
        let newCount = elements.count
        let end = first + (newCount - oldCount) + subRange.count
        arrayDidChange(ArrayChangeEvent(inserted: Array(first..<end),
                                        deleted: Array(subRange.lowerBound..<subRange.upperBound)))
    }
}

extension ObservableArray: CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }
}

extension ObservableArray: CustomStringConvertible {
    public var debugDescription: String {
        return elements.debugDescription
    }
}

extension ObservableArray: Sequence {

    public subscript(index: Int) -> Element {
        get {
            return elements[index]
        }
        set {
            elements[index] = newValue
            if index == elements.count {
                arrayDidChange(ArrayChangeEvent(inserted: [index]))
            } else {
                arrayDidChange(ArrayChangeEvent(updated: [index]))
            }
        }
    }

    public subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        get {
            return elements[bounds]
        }
        set {
            elements[bounds] = newValue
            let first = bounds.lowerBound
            arrayDidChange(ArrayChangeEvent(inserted: Array(first..<first + newValue.count),
                                            deleted: Array(bounds.lowerBound..<bounds.upperBound)))
        }
    }
}


extension ObservableArray where Element: Comparable {
    
    @discardableResult
    public mutating func sort() -> ObservableArray {
        self.elements = self.sorted()
        self.arrayDidChange(ArrayChangeEvent(updated: Array(0..<self.count)))
        return self
    }
}

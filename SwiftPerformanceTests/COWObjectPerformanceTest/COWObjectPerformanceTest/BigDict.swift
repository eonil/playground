//
//  BigDict.swift
//  CopyPerformanceTest
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

struct BigDict<K:Hashable,V> {
        init() {
                self.box = Box([:])
        }
        var state: [K: V] {
                get {
                        return box.state
                }
                set {
                        if isUniquelyReferenced(&box) == false {
                                box = Box(newValue)
                        }
                        else {
                                box.state = newValue
                        }
                }
        }
        subscript(k: K) -> V? {
                get {
                        return box.state[k]
                }
                set {
                        box.state[k] = newValue
                }
        }
        var count: Int {
                get {
                        return box.state.count
                }
        }
        private var box: Box<[K: V]>
}
final class Box<T>: NonObjectiveCBase {
        init(_ state: T) {
                self.state = state
        }
        var state:T
}

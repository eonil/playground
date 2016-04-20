//
//  BigDict.swift
//  CopyPerformanceTest
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

struct BigDict<K:Hashable,V> {
        init() {
                self.cowbox = COWBox([:])
        }
        var state: [K: V] {
                get {
                        return cowbox.state
                }
                set {
                        if isUniquelyReferenced(&cowbox) == false {
                                cowbox = COWBox(newValue)
                        }
                        else {
                                cowbox.state = newValue
                        }
                }
        }
        subscript(k: K) -> V? {
                get { return cowbox.state[k] }
                set { cowbox.state[k] = newValue }
        }
        var count: Int {
                get { return cowbox.state.count }
        }
        private var cowbox: COWBox<[K: V]>
}
final class COWBox<T>: NonObjectiveCBase {
        init(_ state: T) {
                self.state = state
        }
        var state:T
}

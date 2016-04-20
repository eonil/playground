//
//  main.swift
//  CopyPerformanceTest
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import CoreMedia

func measure(label: String, f: ()->()) {
        let begin = CACurrentMediaTime()
        f()
        let end = CACurrentMediaTime()
        let seconds = round((end - begin) * 1_000) / 1_000
        print("\(label): \(seconds)sec")
}

struct BigObject1 {
        var items: Array<String> = Array(Repeat(count: 1024 * 1024 * 32, repeatedValue: "abcd"))
}

/// Seems RVO (copy elision) works on Swift.
func test1(a: BigObject1) -> BigObject1 {
        var b = a
        b.items.removeLast()
        if a.items.count == 0 {
                return b
        }
        else {
                return a
        }
}

for _ in 0..<4 {
        measure("Instantiate") {
                var a = BigObject1()
        }
        do {
                var a: BigObject1?
                measure("Instantiate...") {
                        a = BigObject1()
                        print(a!.items.count) // To prevent static optimization.
                }
                measure("Copy (expects elision)") {
                        var b = a
                        print(b!.items.count) // To prevent static optimization.
                }
                measure("Copy and modify.") {
                        var b = a
                        b!.items.removeLast()
                        print(b!.items.count) // To prevent static optimization.
                }
                measure("... copy, return and reassign-back. (RVO test)") {
                        var a1 = test1(a!)
                        print(a1.items.count) // To prevent static optimization.
                }
                measure("... copy, return, reassign-back and modify.") {
                        var a1 = test1(a!)
                        a1.items.removeLast()
                        print(a1.items.count) // To prevent static optimization.
                }
        }
}






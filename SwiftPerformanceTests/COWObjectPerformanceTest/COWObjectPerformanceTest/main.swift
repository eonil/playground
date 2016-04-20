//
//  main.swift
//  CopyPerformanceTest
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import CoreMedia

// COW object is slower to create, but far faster when dealing with object graph
// because it guarantees avoiding of copying.
//
// Swift's primitive dictionary does not provide non-copying object mutation.
// This is a kind of linguistic limitation. We can overcome this limitation partially
// by using COW obejcts. Anyway, it still has its shorcomings...

func measure(label: String, f: ()->()) {
        let begin = CACurrentMediaTime()
        f()
        let end = CACurrentMediaTime()
        let seconds = round((end - begin) * 1_000) / 1_000
        print("\(label): \(seconds)sec")
}

for _ in 0..<4 {
        measure("Swift.Dictionary with 1024 * 4 samples") {
                let SAMPLE_COUNT = 1024 * 4
                var a = Dictionary<Int,Dictionary<Int,String>>()
                for i in 0..<(4) {
                        var b = Dictionary<Int,String>()
                        for j in 0..<SAMPLE_COUNT {
                                b[j] = "\(j)"
                        }
                        a[i] = b
                }
                print(a.count)
                print(a[1]?[64])
                for i in 0..<4 {
                        for j in 0..<SAMPLE_COUNT {
                                a[i]?[j] = "C"
                        }
                }
                print(a.count)
                print(a[1]?[64])
        }
        /// This is about 32x faster than above naive copying implementation.
        /// Take care that this test code does not make any copy.
        /// A copy has to be made, the performance will be dropped horribly
        /// even worse than naive copy.
        measure("BigDict with 1024 * 128 samples (32x more)") {
                let SAMPLE_COUNT = 1024 * 128
                var a = BigDict<Int,BigDict<Int,String>>()
                for i in 0..<(4) {
                        var b = BigDict<Int,String>()
                        for j in 0..<SAMPLE_COUNT {
                                b[j] = "\(j)"
                        }
                        a[i] = b
                }
                print(a.count)
                print(a[1]?[64])
                for i in 0..<4 {
                        for j in 0..<SAMPLE_COUNT {
                                a[i]?[j] = "C"
                        }
                }
                print(a.count)
                print(a[1]?[64])
        }
}






















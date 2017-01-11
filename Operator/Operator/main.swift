//
//  main.swift
//  Operator
//
//  Created by ShuichiNagao on 10/9/16.
//  Copyright © 2016 ShuichiNagao. All rights reserved.
//

import Foundation

// 中置関数をinfix
// associativityは結合規則、left/right/noneがあって同じ優先順位のものがあったときにどっちを優先するかどうか
// precendenceは優先順位(3 + 4 * 5 は右が優先されるよねってこと。precedenceが高い方が優先される)
infix operator ≤ { associativity none precedence 130 }

public func ≤ <T: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs <= rhs
}

let result = 3 ≤ 4
//print(result)

let ar: Array<Int>

infix operator ≠ { associativity none precedence 130 }

public func ≠ <T: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs != rhs
}



print(3 ≠ 4)

struct Person {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        
        self.name = name
        self.age = age
        
    }
}


let A = Person(name: "Tom", age: 22)
let B = Person(name: "John",age: 33)

//print(A = B)
print(A.age ≠ B.age)






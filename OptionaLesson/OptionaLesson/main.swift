//
//  main.swift
//  OptionaLesson
//
//  Created by ShuichiNagao on 9/4/16.
//  Copyright © 2016 ShuichiNagao. All rights reserved.
//

import Foundation

print("Hello, World!")

var str1: String?

print(str1)

//var str2 = str1!

struct Str {
    var str1: String
    var num2: Int
    
    init(st: String, num: Int) {
        self.str1 = st
        self.num2 = num
    }
}

let aaa = Str(st: "hi", num: 3)
print(aaa)

str1 = "dfjklfjas;l"

let str2 = str1?.uppercaseString
print(str2)

guard let str3 = str1?.uppercaseString else {
    exit(0)
}

print(str3)

let array = [1, 4, 6, 8, 7]

array.sort { (a: Int, b: Int) -> Bool in
    return a > b
}


//
//  main.swift
//  hensu
//
//  Created by ShuichiNagao on 10/14/16.
//  Copyright © 2016 ShuichiNagao. All rights reserved.
//

import Foundation

print("Hello, World!")

//let tuple = (status: 200, message: "OK")
// 名前ありはextensionで拡張できる
// 名前つけると構造体っぽくなる


//tuple.0
//tuple.status
//tuple.1
//tuple.message

//let (status, message) = tuple
// 同時に変数にだいにゅうできる

//status
//message

func request() -> (Int, String) {
    
    return (200, "OK")
}

//let (stat, mess) = request()
//
//stat
//mess


do {
    
    class Response {
        
        
        init() {
            self.status = 0
            self.message = "init"
        }
        
        var status: Int
        var message: String
    
        func update() {
            let condition = 1

            // タプルとクロージャを使うとひとまとまりにしてプロパティを管理できる。
            (status, message) = { () -> (Int, String) in

                switch condition {
                case 1:
                    return (200, "aaa")
                default:
                    return (200, "aaa")

                }
            }()
        }
    
    
    
    }
    
    let response = Response()
    
    print(response.status)
//    response.message
}


struct Value {
    var v1: Int
    var v2: String
}

func doSome() -> (Int, String)? {
    return (2, "A")
}
// mapにinitを渡すことができる
var result = doSome().map(Value.init)
print(result)

func doSome2<T>(v: T, f: (T) -> Bool) -> Bool {
    return f(v)
}
// tupleを渡して分解して複数の引数を持つもののように扱うことができる
doSome2((1, 2)) { (a: Int, b: Int) -> Bool in
    return a == b
}



var value: Int?

value = 2


struct MyValue {
    let v1: Int
    
    func toInt() -> Int {
        return v1
    }
}

// bigEndinanは16bitを後ろを先に保存するか
// 型に変換イニシャライザを使う。第一引数は_にしている。ラベルがないから途中で変わったりしない
extension Int {
    init (_ value: MyValue) {
        self = value.toInt()
    }
}
//
let v = MyValue(v1: 10)
let intValue = v.toInt()
let intValue2 = Int(v)
print(intValue2)

// スコープを抜けた時に元の方に書き戻す、willSet, didSetはこれを抜けてから
//func write(value3: inout Int) {
//    value3 = 100
//}
//
//var value3 = 0
//
//write(value3: &value)
//
//value3


do {
    
//    func doSomething3(v: inout Int) throws {
//        
//    defer {
//        v = 1000
//    }
    
    
//        v = 100
//        // 無理やりエラーを投げてる
//        throw NSError
//    }
//    
//    var value = 1
//    
//    do {
//        try doSomething3(v: &value)
//        
//    } catch {
//        
//    }
    
    
}

//for v in stride(from: 0, to: 100, by: 2) {
//    print(v)
//}



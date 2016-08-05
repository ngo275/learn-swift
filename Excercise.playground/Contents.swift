//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// optionalという箱の中身をいじりたい時、Ortional bindingは冗長であり、こういう時に、mapやflatmapが有用



func square(x: Int) -> Int { // 引数を二乗して返す関数
    return x * x
}
var a: Int? = 3
print(a ?? 0)
a.map(square) // map メソッドの引数 f に関数 square を渡す

// このようにいちいちa.mapに入れるための関数を書くのはだるい。そこでクロージャで書こう！
a.map { (x: Int) -> Int in
    return x * x
}
a.map { (x: Int) -> Int? in x * x}
a.map { x in x * x }
var ee = a.map { $0 * $0 }
print(ee)
// nilが帰ってくるかもしれない操作の返り値はoptionalになる。
// first の型は Int?
// map は値を Optional で包みなおして返すので Optional が二重になる
var array: [Int]?
let result0: Int?? = array.map { $0.first }
// !で一つ箱を開けれるが危険である。しかし??を使うと安全に開けれる！！
let result1: Int? = array.map { $0.first } ?? nil
// ほかにもOptional Chainingがある。これは上のやつの中でも簡単なものにしか使えない。チェーンメソッド的にかけて、nilが出てきたらそこでストップしてnilで返すという仕組み。flatmapで全て書き換え可能。Optional chaining は flatMap の一部のケースを簡単に書くためのシンタックスシュガー
let result2: Int? = array?.first

// mapの例のようoptionalが二重になるのを避けるために生まれたのflatmap
let result3: Int? = array.flatMap { $0.first }




let b: Int? = 3
let c: Int? = 4
// bとcの足し算をしたい
// mapを使うとこうなって気持ち悪い
let result4: Int?? = b.map { b0 in c.map { c0 in b0 + c0 } }
// flatmapを使って見る。
let result5: Int? = b.flatMap { b0 in c.map { c0 in b0 + c0 } }
let result6: Int? = b.flatMap { b0 in c.flatMap { c0 in Optional(b0 + c0) } }
let result7: Int? = b.flatMap { b0 in c.flatMap { c0 in b0 + c0 } }// Intは、上のようにOprionalで明示的にOptionalで包まなくても良い。自作の型ならラッピングしないといけない
let result8: Int? = a.flatMap { a0 in b.flatMap { b0 in c.map { c0 in b0 + c0 } } }
// 一番内側は失敗しない処理だからmapでかく。外側はflatMap。result6のようにもかける。
// optionalの数が増えればその分flatMapの入れ子で書くことになる。

// PromiseもOptionalを全く同様に考えられる（flatMapを使うと完全一致）。Promiseは今は値はないけど、あるものとして先に計算をしておくイメージ。モナドの特徴を捉えている。
// ArrayもOptionalやPeomiseと同じモナドである。
let d: Array<Int> = [3]
let e: Array<Int> = d.map { $0 * $0 }
let f: Array<Int> = d.flatMap { d0 in e.flatMap { e0 in [d0 + e0] } }
// mapの返り値を使わない時はforEachを使ったほうが良い。
d.forEach { print($0) }


enum MyOptional<T> { // 自作 Optional
    case None
    case Some(T)
}

let g: Optional<Int> = 3 // OK → Int|None っぽい挙動. Optionalで包まなくても代入できる
//let h: MyOptional<Int> = 3 // コンパイルエラー
let h: MyOptional<Int> = .Some(3) // Optional で包む必要あり





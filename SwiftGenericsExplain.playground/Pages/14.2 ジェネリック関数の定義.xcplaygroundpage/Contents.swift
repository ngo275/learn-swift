//: [Previous](@previous)

import Foundation


//: [Next](@next)

// 【14.2】ジェネリック関数の定義

// ■ ジェネリック関数の定義

do {
    func mySwap(inout a:Int, inout _ b:Int) {
        let t = a; a = b; b = t
    }
}

do {
    func mySwap<T>(inout a:T, inout _ b:T) {
        let t = a; a = b; b = t
    }

    // 文字列やタプルに対しても動作することが確認できる。
    var a = "Aria", b = "Jeanne"
    mySwap(&a, &b)
    print("a=\(a), b=\(b)") // a=Jeanne, b=Aria

    var s = (1, 2), t = (100, 50)
    mySwap(&s, &t)
    print("s=\(s), t=\(t)") // s=(100, 50), t=(1, 2)

    // タプルについても実行できる
    // （同じ要素を持ち、それぞれが同じ型でなければならない）
    var v = ((2, 3), 9, (88, 108))
    mySwap(&v.0, &v.2)
    print(v) // ((88, 108), 9, (2, 3))
}


// 2つの辞書型データの内容を足し合わせて新しい辞書を作成するために
// 「+」演算子にオーバーロード定義を行います。

func +<Key, Value>(lhs:[Key:Value], rhs:[Key:Value]) -> [Key:Value] {
    var dic = lhs
    for (k, v) in rhs { dic[k] = v }
    return dic
}

let p = ["レベル":60, "特技":10]
let q = ["番号":1]
let pq = p + q
print(pq) // ["番号": 1, "レベル": 60, "特技": 10]



// ■ 型パラメータの書き方

// <T>
// 関数定義、型定義に書くことによって、
// それ以下の定義でTを型パラメータとして使うことを示します。
// Tに対する条件はない。

// <T, U>
// 型パラメータが2つ必要な場合はこのように記述する。

// <T: OtherType>
// 型パラメータTは、プロトコルOtherTypeに適合するか、
// クラスOtherType自体か、そのサブクラスであることが条件となる。

// <... where 条件>
// 先行する型パラメータに何らかの条件を付ける。
// 条件は以下のようになる。
// 複数の条件をカンマ「,」で区切って並べ、AND条件を表すこともできる。

//     T: OtherType
//     型パラメータTがプロトコルOtherTypeに適合するか、
//     クラスOtherType自体か、あるいはそのサブクラスであることを条件とする。

//     T == U
//     型パラメータT（または型T）は、
//     型パラメータU（または型U）と同じであることを条件とする。


// Swiftの標準ライブラリで使用されている例

// <Bound: Comparable>
// 型Boundは、プロトコルComparableに適合している

// <T : RawRepresentable where T.RawValue : Equatable>
// 型TはプロトコルComparableに適合し、
// さらにTの付属型RawValueはプロトコルEqutableに適合している。

// <C : CollectionType 
//     where C.Index : ForwardIndexType,
//           C.Generator.Element == Element>
// 型CはプロトコルCollectionTypeに適合する。
// ただし、Cの付属型IndexはプロトコルForwardIndexTypeに適合し、
// さらにCの付属型Generatorの付属型Elementは（このメソッド定義を含む型の付属型の）Elementと同じ型である。

// Swiftの任意のインスタンスを表す型としてAny型が用意されている。
// public typealias Any = protocol<>


// Objective-Cのオブジェクトに互換のインスタンスを表すためにAnyObject型がある。
// Objective-Cのオブジェクトとして扱えることを示す@objc属性が付いている。
// @objc public protocol AnyObject {


// ■ プロトコルによる制約のあるジェネリック関数

// プロトコルComparableを使った例

//func mySwap(inout little a:Int, inout great b: Int) {
//    if a > b {
//        let t = a; a = b; b = t
//    }
//}

// 型Tは大小比較をする必要があるため、プロトコルComparableに適合することを条件とする。
func mySwap<T: Comparable>(inout little a:T, inout great b:T) {
    if a > b {
        let t = a; a = b; b = t
    }
}

// プロトコルComparableに適合するように定義した列挙型WeekDay
enum WeekDay: Int, Comparable {
    case Sun, Mon, Tue, Wed, Thu, Fri, Sat
}

func ==(lhs: WeekDay, rhs: WeekDay) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

func <(lhs: WeekDay, rhs: WeekDay) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

var sun = WeekDay.Sun
var wed = WeekDay.Wed
mySwap(little: &wed, great: &sun)
print(sun.rawValue) // 3


// ■ 型パラメータの推論

// ジェネリック関数を使用する時、型パラメータは明示的に<>を使って記述できない。
// 型パラメータはその引数から推論されることが多いが、返り値から推論されることもある。

func f<T>(n:Int) -> [T?] {
    return [T?](count:n, repeatedValue:nil)
}

// let a = f(3) // 判断材料がないのでエラー

let a:[Int?] = f(3) // OK
let b = f(2) + ["あ"] // OK

// コンパイラはありうるすべての条件を調べるので、
// 複雑な状況下では処理に時間がかかったり、最悪の場合は異常終了することもある。
// あまり複雑な推論をしなくてもよいように、適宜、型宣言をしておくのがよい。


// ■ 関数の引数とタプル

func apply<T,U>(f:(T)->U, _ t:T) -> U {
    return f(t)
}

func spell() { print("void") }
func spell(a:Int) { print(a) }
func spell(a:Int, b:String) { print("\(a): \(b)") }
func spell(a:Int, b:String, c:Int) { print("\(a): \(b)\(c)") }

apply(spell, ()) // void
apply(spell, 1)  // 1
apply(spell, (2, "Kangroo")) // 2: Kangroo
apply(spell, (3, "FG", 204)) // 3: FG204

// このように、ジェネリック関数applyの第2引数をタプルで与え、
// そのタプルに相当する引数を持つ関数を呼び出すことができる。

// 引数がない場合は()を与え、引数が1つだけの場合は単独の値を与えている。

// Swiftでは要素が1つだけのタプルは許されていないが、
// T型に対して形式的に(T)型を作ることができ、
// T型と(T)型は同じものとして扱われる。

var psy: (Int) = 0 // psyはInt型と同じように扱われる

// Swiftの関数は、実際には引数列というよりも
// タプルを与えられて呼び出される仕組みになっているということができる。



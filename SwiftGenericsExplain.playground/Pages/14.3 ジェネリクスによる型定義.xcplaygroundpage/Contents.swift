//: [Previous](@previous)

import Foundation


//: [Next](@next)

// 【14.3】ジェネリクスによる型定義

// ■ 型パラメータを持つ構造体の定義

// List14-5 付属型のあるプロトコルVectorType
protocol VectorType {      // 2次元ベクトル型
    associatedtype Element // 付属型の宣言
    var x : Element { get set }
    var y : Element { get set }
}

// List14-6 型パラメータを持つ構造体Vector
struct Vector<T> : VectorType {
    typealias Element = T // 付属型をパラメータで指定された型で定義
    var x, y: Element     // 格納型プロパティ
}

do {
    let a: Vector<Int> = Vector<Int>(x: 12, y: 3)
    print(a.x, a.y) // 12 3
    let b = Vector<[String]>(x: [], y: ["黒", "noir", "schwarz"])
}

// この定義だけを見ると、付属型のElementは何の役にも立っておらず、無駄のように思われます。
// しかし、ジェネリクス機能を使う上で付属型は不可欠の要素です。
// この例題であれば、付属型がVectorの要素の型を表すため、
// 機能を追加したり他の定義と組み合わせる場合に大変役立ちます。


// ■ ジェネリックなデータ型と型パラメータの推論

// ジェネリック関数では、型パラメータは明示的には指定できず、引数や返り値から推論する。
// 一方、ジェネリックな型は、基本的には<>の中に型を明示して使う。
// ただし、周囲の状況から用意に推論できる時は型パラメータを省略できることがある。

// 例えば、上で定義した構造体Vectorは（この場合、あまり意味はないが）次のように利用できる。

let p = Vector(x: 10.0, y: 2.0/2.5).y // p = 0.8 (Double)

// ただし、このような状況はあまり多くはないと思われる。
// 型の誤りを防止するためにも、通常は型パラメータを明示的に指定すべき。


// ■ 拡張定義の条件に型パラメータを使う

// 型パラメータを持つジェネリックな型や、プロトコルを採用して定義された型は、
// どんな型パラメータを指定したか、実装にどんな型を利用しているか、
// あるいは他にどんなプロトコルを採用しているかなどによって、
// それぞれ具体的な別々の型になる。

// そのようなジェネリックな型やプロトコルに拡張定義を追加しようとしても、
// 具体的なありうるすべての型には適用できない場合がある。

// そこで、拡張定義に、どういう型に適用可能な定義なのかという条件を記述しておくことができる。

// たとえば、ジェネリックな型定義に対して、
// ある一定の場合だけ使えるようにしたいメソッドがあった場合、
// そのメソッドを定義した拡張定義を作成し、追加可能な条件を記述しておく。

// 条件に合致した型はその拡張定義のメソッドを利用できるが、合致していない型からは利用できない。


// extension T
// 条件なしで型Tに拡張定義を追加する。


// extension T: Protocol

// 型TがプロトコルProtocolに適合するようにする。
// プロトコルはカンマ「,」で区切って複数個指定できる。
// なお、プロトコルに適合するために
// 必要な定義や実装がこの拡張定義にすべて含まれている必要はない。


// extension T where 条件
// ジェネリック型Tから作られた型、あるいはプロトコルTに適合する型で、
// where以下に記述された条件に当てはまるものは、この拡張定義を利用できる。
// 条件は以下に示すもので、「,」で区切って複数個指定できる。

//     A == B
//     AとBが同じ型。型パラメータや付属型の間の関係を指定するのに使う。
//     ジェネリック型の場合、A、Bには型パラメータ、付属型を使わなければならない。
//     プロトコルの拡張の場合、Selfや具体的な形名を使うこともできる。

//     A : B
//     AとBが同じ、AがBを継承している、あるいはAがBに適合していることを条件とする。


// プロトコルVectorTypeの付属型ElementがDouble型だった時だけ、
// ベクトルの絶対値（長さ）を計算するメソッドabs()の規定実装を追加する。
extension VectorType where Element == Double {
    func abs() -> Double {
        return sqrt(x * x + y * y)
    }
}

// Vector型に、型パラメータが実数型だったら、キーワードなしのイニシャライザが使えるようにする。
// 構造体の本体の定義では山カッコで型パラメータを指定したが、拡張定義には記述しない。
extension Vector where T : FloatingPointType {
    init(_ x:Element, _ y:Element) {
        self.x = x; self.y = y
    }
}

// 実行例は次のようになる。

do {
    let a = Vector<Double>(8.0, 6.0) // イニシャライザが利用できる
    let b = Vector<Float>(5.0, 1.5)
    print(a.abs()) // 10.0
//    print(b.abs()) // Double型ではないのでエラーになる
}


// ■ プロトコルを採用した型自体に対する制約を記述する

// 配列型にはさまざまな型のインスタンスを格納できるが、
// 相互に比較可能なインスタンスを格納する場合のみ、配列を相互に比較可能になる。


// この定義の書き方は少々妙な感じがする。
// プロトコルVectorTypeの本体の宣言では他のプロトコルを採用していないので、
// 「Self : Equatable」の部分は成立しないように思われる。
// しかし、「VectorType : Equatable」と書かれているのではないところが重要。
// つまり、VectorTypeを採用した何らかの型、Selfが、型パラメータに関する制約を満たす場合、
// Self自体にはEquatableに適合するという制約が付加される、と読むことができる。


// List14-8 プロトコルを採用した型自体に対する制約を記述する例
extension VectorType where Self : Equatable, Element : Equatable { }

func ==<T: VectorType where T.Element: Equatable>(lhs:T, rhs:T) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

// このような記述によって、Elementに関する条件が満たされた場合だけ、
// Self、つまりこのプロトコルVectorTypeを採用している型自体もEquatableに適合するように宣言できる。

// このようにSelfに対する制約を記述できるのはプロトコル拡張だけ。
// 構造体やクラスの拡張定義にはSelfを制約条件として記述できない。


do {
    let a = Vector<Double>(x: 16.0, y: 5.0)
    var b = Vector<Double>(x: 10.0, y: 5.0)
    print( a == b ) // false
    b.x += 6.0
    print( a == b ) // true
}


// ■ ジェネリックなクラスを定義する

// 型パラメータを持つクラスを定義し、
// さらにそのクラスを継承して別のクラスを定義することができます。

class Position<T> {
    typealias Element = T
    var x, y: Element
    init(_ x:Element, _ y:Element) {
        self.x = x; self.y = y
    }
}

// 型パラメータに制約を付けて、実数のみが使用できるようにする
class Bullet<T:FloatingPointType>: Position<T> {
    init(x:Element, y:Element) { super.init(x, y) }
}

// 型パラメータをInt型に限定して継承している
class Piece: Position<Int> {
    enum Color { case White, Blue }
    let color: Color
    init(color:Color, _ x:Int, _ y:Int) {
        self.color = color; super.init(x, y)
    }
}

do {
    let b = Bullet<Float>(x: 100.0, y: 67.9)
    let p = Piece(color: .Blue, 2, 4)
}


// ■ プロトコルSequenceTypeを調べよう

// SequenceType
// ひとまとまりのインスタンスを管理する機能をまとめたもの。
// 範囲型や配列などがこのプロトコルに適合している。


// List14-10 プロトコルSequenceTypeとGeneratorType

// 面白いことに、プロトコルSequenceType自体には要素のインスタンスが何型なのかという情報がない
// あちこちにGenerator.Elementと書かれているのはそういう理由。
protocol SequenceType {
    associatedtype Generator : GeneratorType

    // さまざまな操作の結果として要素の部分集合を作成することがあるが、
    // そのような場合、一時的にインスタンスを共有し、
    // できるだけコピーを後回しにして高速化を図る方法が用いられる。
    associatedtype SubSequence

    func generate() -> Self.Generator
    func map<T>(@noescape transform: (Self.Generator.Element) throws -> T) rethrows -> [T]
    func filter(@noescape includeElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element]
    func prefix(maxLength: Int) -> Self.SubSequence
    func suffix(maxLength: Int) -> Self.SubSequence
    // 以下、関数定義をいくつか省略
}

// プロトコルGeneratorTypeはインスタンスの集まりの具体的な管理方法を
// プロトコルSequenceTypeから切り離したものと考えられる。
protocol GeneratorType {
    associatedtype Element
    mutating func next() -> Self.Element?
}

// プロトコルSequenctTypeは、要素のインスタンスを取り出す必要が生じたら
// メソッドgenerate()を使ってプロトコルGeneratorTypeに適合するインスタンスを作る。

// このインスタンスのメソッドnext()は、
// 管理している要素の中から順番に1つずつ取り出し、すべて取り出し終わったらnilを返す。
// プロトコルSequenceTypeはインスタンス管理の具体的な方法を知る必要はない。

// List14-11 プロトコルSequenceTypeの拡張定義の例

// 要素の型がプロトコルComparableに適合していることを、拡張定義の条件にしている。
// 相互に大小比較が可能ということなので、
// 並び替えを行うメソッドsort()が利用可能であるように宣言する。返り値は配列。

//extension SequenceType where Self.Generator.Element : Comparable {
//    func sort() -> [Self.Generator.Element]
//}


// プロトコルEquatableに適合していることが条件。
// 指定したものと同じ要素が存在するかを調べるメソッドcontains(_:)が利用可能であるように宣言。

//extension SequenceType where Generator.Element : Equatable {
//    func contains(element: Self.Generator.Element) -> Bool
//}


// 要素がStringであることを条件にしている。
// 引数で指定した文字列を区切りにして、すべての要素を連結して返すメソッドを宣言する。

//extension SequenceType where Generator.Element == String {
//    func joinWithSeparator(separator: String) -> String
//}


// ■ プロトコルCollectionTypeを見てみよう

// プロトコルCollectionTypeはSequenceTypeに加えてIndexableを継承している。

//public protocol CollectionType : Indexable, SequenceType {

// 付属型Generatorとメソッドgenerate()の関係は、SequenceTypeの場合と同様。
// IndexingGeneratorは構造体で、それ自体がSequenceTypeに適合している。
//    associatedtype Generator : GeneratorType = IndexingGenerator<Self>
//    public func generate() -> Self.Generator

//    associatedtype SubSequence : Indexable, SequenceType = Slice<Self>

// 添字を使って要素のインスタンスにアクセスできる。
// 添字の型はプロトコルIndexableから継承した付属型のIndex。
// 要素は更新できない。CollectionTypeを継承したプロトコルMutableCollectionTypeが、
// 添字を指定して要素を更新する機能を提供する。
//    public subscript (position: Self.Index) -> Self.Generator.Element { get }

//    public subscript (bounds: Range<Self.Index>) -> Self.SubSequence { get }
//    public func prefixUpTo(end: Self.Index) -> Self.SubSequence
//    public func suffixFrom(start: Self.Index) -> Self.SubSequence
//    public func prefixThrough(position: Self.Index) -> Self.SubSequence
//    public var isEmpty: Bool { get }
//    public var count: Self.Index.Distance { get }
//    public var first: Self.Generator.Element? { get }
//}

//public protocol Indexable {

// Indexには、プロトコルForwardIndexTypeに適合するという条件が付いている。
// メソッドsuccessorを呼び出すことで1つ大きなインスタンスを返す型を表す。
//    associatedtype Index : ForwardIndexType
//    public var startIndex: Self.Index { get }
//    public var endIndex: Self.Index { get }
//}


// プロトコルMutableCollectionTypeに適合した代表的なデータ型がArray。
// 配列の場合、添字のIndex型は整数として定義されている。
// 添字間の差を表すIndex.Distanceも整数。
// 付属型のSubSequenceにはArraySlice型が使われる。

// Swiftの標準ライブラリで提供されているプロトコルや構造体の定義は、
// 互いに極めて緻密に組み合わされており、一見しただけでは関係性が把握できない。



//: Playground - noun: a place where people can play

import UIKit

//: #クロージャ
/*:
 ## キャプチャ例
 クロージャは定義されたスコープにあるものを参照保持する。入っている値ではなく参照自体を保持する。キャプチャ位している値を書き換えたらクロージャに反映される。
```
let greeting: (String) -> String
do {
    let symbol = "!"
    greeting = { user in
        return "Hello \(user)\(symbol)"
    }
}
greeting("ngo275")
//print(symbol) <= error

let counter: () -> Int
do {
    var count = 0
    counter = {
        count += 1
        return count
    }
}
counter()
counter() // 参照自体を保持しているので値が都度書き換わる
```
 
 */

/*:
 ## クロージャの属性
 - @escaping: 
    
    関数の引数にclosureを渡す時、その関数の外側で引数に入れてあるclosureが参照されている時に必要。キャプチャしないといけない時に、@escapingをつける
 
 - @autoclosure:
    
    Swiftは関数に引数が渡される前に引数が実行される（正格評価）。引数が複数あって、その引数に関数の返り値をそのまま入れる時を考える。二つ目の引数が必要なくなった時にも二つ目の引数が計算されてしまう。それを防ごうとすると、二つ目の引数にはクロージャを入れて、遅延評価させることになる。ただ、そうすると呼び出し側がクロージャを入れないといけなくなって( `{return funchoge()}` )煩雑さがでてくる。@autoclosureをつけることで、呼び出し元の煩雑さが回避される。@autoclosureは暗黙的にクロージャでラッピングしてくれる。 `funchoge()` だけでよくなる。
 
 ```
 func or(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    if lhs {
        print("true")
        return true
    } else {
        let rhs = rhs()
        print(rhs)
        return rhs
    }
 }
 ```
 */

/*:
 structは継承関係がないからinitがめんどくさくないが、classは継承がありinitが若干複雑になる

```
struct sample {
    var hoge: Int
}

class sample2 {
    var hoge: Int // コンパイルエラー
}
```
*/

/*:
 genericの型制約
 ```
 func sorted<T: Colletion>(_ argument: T) -> [T.Iterator.Element] where T.Iterator.Element: Comparable {
    return argument.sorted()
 }
 ```
*/

/*:
 ## classにできてprotocolにできないこと
 ストアドプロパティやプロパティオブザーバーはprotocolに実装できないので、採用してからclassやstruct側で実装しないといけない。classだと親クラスに実装しておいて継承すればいい。
*/

/*:
 ## !が有効なケース
 
 サブクラスのinit時にsuper.init()をしないとスーパークラスのプロパティにはアクセスできないのだが、サブクラスのプロパティがinitされていないとsuper.init()を呼べないため。
 プロパティをinitするのが厄介な時に!を使っておく
 
 */

/*:
 ## Never型
 fatalError("ここで強制終了")
 return Intすべきでもこれで抜けられる。実装の途中でもつかえる。
 */

/*: 
 ## コンパイルの最適化
  `-0none` をコンパイル時に指定するとコンパイルの最適化が行われず（デバッグモード）、 `-0` とするとコンパイルの最適化が行われる（リリースモード）。assertは条件を満たさない時に終了する関数で、これはデバッグモードの時に有効になる。
 
 ```
 func format(minute: Int, second: Int) -> String {
    assert(second < 60, "secondは60未満にしてください")
    return "\(minute)分\(second)秒"
 }
 ```
 
 assertionFailureは必ず条件なしに強制終了する。switchのdefaultとかに入れておくと強制終了とかできる。
 
 ただし、これらのと違って `fatalError` はリリースモードでも強制終了される。
 */

/*: 
 ## Error処理の使い分け
 - Optional<Wrapped>
  エラーの詳細情報が不要で結果の成否によってエラーを扱う場合
 - Result<T, Error>
  非同期処理の場合
 - do-catch文
  同期処理の場合
 - fatalError(_:)
  エラー発生時にプログラムを強制終了したい時
 - アサーション
  デバッグの時のみエラー時にプログラムを強制終了したい時
 */



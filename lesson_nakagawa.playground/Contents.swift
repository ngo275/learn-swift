//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var str1: String?

print(str1)

//var str2 = str1!

let array = [1, 4, 6, 8, 7]

array.sort { (a: Int, b: Int) -> Bool in
    return a > b
}

array.sort { (a, b) in
    return a > b
}

array.sort { (a, b) in a > b }

array.sort { $0 > $1 }

array.sort(>)

array.reduce(0) { (a: Int, b: Int) -> Int in
    a + b
}

array.reduce(0) { $0 + $1 }

array.reduce(0, combine: +)

let k = array.reduce(0) { $0 + $1 }
print(k)

let celsius = ["Tokyo":14.0, "Osaka":17.0, "Okinawa":26.0]

let fahrenheit =
    celsius.map { ($0.0, 1.8 * $0.1 + 32) } // [("Okinawa", 78.8), ("Tokyo", 57.2), ("Osaka", 62.6)]
        .filter { $0.1 > 60 } //[("Okinawa", 78.8), ("Osaka", 62.6)]
        .map { $0.0 } // ["Okinawa", "Osaka"]

array.filter{$0 < 7}

//enum Day {
//    case Sun, Mon, Tue, Wed, Thu, Fri, Sta
//    
//    var day: String {
//        get {
//            switch self {
//            case .Sun:
//                return "Sun"
//            case .Mon:
//                return "Mon"
//            case .Thu:
//                return "Thu"
//            default:
//                return ""
//        }
//    }
//}

struct MyDate {
    var year = 2016
    var month = 1
    var date = 1

    var day: Int {
        return (year + year/4 - year/100 + year/400 + (13 * month + 8)/5 + date) % 7
    }
    
    init() {
        self.year
        self.month
        self.date
    }
    
    init?(year: Int, month: Int, date: Int) {
        
        if year < 1 { return nil }
        if date < 1 { return nil }
        
        var isLeap: Bool {
            if year % 400 == 0 {
                return true
            } else if year % 4 == 0 && year % 100 != 0 {
                return true
            }
            return false
        }
        
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            if date > 31 {
                return nil
            }
        case 2:
            let checkedDate = isLeap ? 29 : 28
            if date > checkedDate {
                return nil
            }
        case 4, 6, 9, 11:
            if date > 30 {
                return nil
            }
        default:
            return nil
        }
        
        self.year = year
        self.month = month
        self.date = date
    }
    
    func returnDate() -> String {
        return "\(year)年\(month)月\(date)日\(day)曜日"
    }
    
}

let date = MyDate()
date.returnDate()
let date2 = MyDate(year: 2014, month: 22, date: 21)
let date3 = MyDate(year: 2004, month: 2, date: 29)
date3?.returnDate()
date3?.day


//class Test {
//    var a: Int?
//    
//    func test2() {
//        // structはweakしなくても問題ない。コピーしているから
//        self.test {[weak self] in
//            self?.a
//        }
//    }
//    
//    func test() {
//        print("testがよばれました")
//    }
//}



struct Eel {
    enum EelRank: Int { // IntじゃないとrawValueを利用できない
        case 並
        case 中
        case 上
        case 特上
        
//        func setaa() -> String {
//            switch self {
//            case .並:
//                return "800"
//            case .中:
//                return "1500"
//            case .上:
//                return "2000"
//            case .特上:
//                return "時価"
//            }
//        }

    }
    
    var price = [800, 1500, 2000]
    var priceless = "時価"
    
    subscript(index: Int) -> String {
        get {
            switch index {
            case 0,1,2:
                return String(price[index])
            case 3:
                return priceless
            default:
                return ""
            }
        }
    
    }
    
//    let eel = EelRank()
//    eel.set(self.price, self.priceless)
    
    
}

let eel1 = Eel()

//この[]の部分をsubscriptと言って、上のsubscriptを設定すると[]でアクセスした時の返り値を設定できる
print(eel1[Eel.EelRank.並.rawValue])
// 800
print(eel1[Eel.EelRank.特上.rawValue])
// 時価


enum EelSize: String {
    case 並 = "並"
    case 中 = "中"
    case 上 = "上"
    case 特上 = "特上"
}

// enumはcaseの中のいずれに当てはまるのかを必ず指定する. これはエラー
//let eel2 = EelSize()
let eel2 = EelSize.init(rawValue: "並") // EelSize型
print(eel2) // 並
let eel3 = EelSize.並 // EelSize型
print(eel3) // 並
let eel4 = EelSize.並.rawValue // String
print(eel4) // "並"

// Intを指定しておくと勝手に連番を振ってくれる.
enum EelOrder: Int {
    case 並 = 1
    case 中
    case 上
}

let eel5 = EelOrder.並.rawValue
print(eel5)
// 1

// Intを指定してそれぞれに任意の数字を振ることも可能.
enum EelPrice: Int {
    case 並 = 800
    case 中 = 1500
    case 上 = 2000
}

let eel6 = EelPrice.上.rawValue
print(eel6)
// 2000

enum EelType: Int {
    case 並 = 1, 中, 上, 特上
    
    // 実装型のプロパティの宣言
    var price: Int {
        get {
            switch self {
            case .並:
                return 800
            case .中:
                return 1500
            case .上:
                return 2000
            case .特上:
                return 2500
            }
        }
    }
    
    // これはコンパイルエラー. 変数型のプロパティは宣言できない.
    // var price2: Int = 3000
    
    // メソッドの宣言
    func isNot特上() -> Bool {
        return self != .特上
    }
}


let eel7 = EelType.並
print(eel7)
// 並
let eel8 = EelType.並.rawValue
print(eel8)
// 1
let eel9 = EelType.並.price
print(eel9)
// 800
let eel10 = EelType.並.isNot特上()
print(eel10)
// true


struct StockTrade {
    
    enum Trade {
        case Buy(stock: String, amount: Int)
        case Sell(stock: String, amount: Int)
    }
    
    //注文処理 銘柄や金額はTradeに全て含まれているので引数はTradeのみ
    func order(type: Trade) {
        //買いもしくは売り注文を処理する
        switch type {
        case let Trade.Buy(stock, amount):
            print("\(stock)株を\(amount)購入する")
        case let Trade.Sell(stock, amount):
            print("\(stock)株を\(amount)売却する")
        }
        
    }
    
}

struct Video {
    
    enum Status {
        
        case Play(title: String)
        case Stop
    
    }
    
    func watch(status: Status) -> String {
        switch status {
        case let Status.Play(title):
            return "\(title)を再生中"
        case .Stop:
            return "停止中"
        }
    }

}

let video = Video()
let label = video.watch(.Play(title: "FullHouse"))




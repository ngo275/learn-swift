//: Playground - noun: a place where people can play

import UIKit

// --------------------------------------

// クールなOptional Bindingの方法。'where'の活用

// アンラップと条件指定を同時にするときは以下のようにif let + whereを活用すると良い。
// if let + caseを簡略化したイメージ。
return apiManager.get(url, params: params, serializer: serializer).map { [weak self] data in
    if let `self` = self where isLoadMore {
        // ifの中でもself（予約語）をつかいたい。そういう時は``でくくる。
        let newArticles = self.mergeArticles(data.articles)
        return (maxArticle: data.maxArticle, articles: newArticles)
    }
    return data
}

// 上と同じ意味。whereを使わずにguard letではやめに返す。
return apiManager.get(url, params: params, serializer: serializer).map { [weak self] data in
    // selfがnilの時は早めに返す。これはイディオム的に覚えておく。
    guard let `self` = self else { return data }

    if (isLoadMore) {
        let newArticles = self.mergeArticles(data.articles)
        return (maxArticle: data.maxArticle, articles: newArticles)
    }
    return data
}

// --------------------------------------

// 複数の配列を結合する・操作する方法

// tabBarという配列があり、その中にはitemsというプロパティがある。viewControllerという配列もある前提。
// ２つの配列をそれぞれバラして結合するには'zip'を使う。配列の中身の数が異なる時は短い方に合わせられる。
// zip + forEachが便利な組み合わせ
zip(tabBar.items!, viewControllers).forEach { (item, vc) in
    let data = self.getTabBarData(vc)
    item.title = data.0
    item.image = data.1
}

// --------------------------------------

// 自作したビューの利用方法

// Nibファイルを呼び出してカスタムビューを描画するためのプロトコル
// Protocols/NibLoadable.swiftにこの二つを書くと良い
protocol NibLoadable: class {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

// ViewControllerでカスタムビュー描画する時に使うメソッド、あらかじめxibファイルを作成しておく
// Utilities/Utils.swiftに書くと良い
static func createView<T: NibLoadable>(owner: AnyObject?) -> T {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    return nib.instantiateWithOwner(owner, options: nil)[0] as! T
}

// カスタムビュー（セルではない）を描画する時
// T型だからこの関数を使う時は型を明示しないといけない（ViewNameとしているところ）
let customView: ViewName = Utils.createView(self)

// --------------------------------------

// 自作したテーブルビューセルの利用方法

// カスタムビューセルを描画するためのプロトコル
// Protocols/Reusable.swiftにこの二つを書くと良い
protocol Reusable: class {
    static var defaultReuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

// ViewControllerでカスタムビューセル描画する時に使うメソッド、あらかじめxibファイルを作成しておく（上のはセルではない）
extension UITableView {
    func register<T: UITableViewCell where T: Reusable>(registerCell _: T.Type) {
        registerClass(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func register<T: UITableViewCell where T: protocol<Reusable, NibLoadable> >(registerCell _: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.defaultReuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

// カスタムビュー（セルではない）を描画する時
// T型だからこの関数を使う時は型を明示しないといけない（ViewNameとしているところ）
// registerは上の方で書けば良い
// 下の式はCellForRowAtIndexPathで書けば良い
tableView.register(registerCell: SNSShareCell.self)
let cell: SNSShareCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

// --------------------------------------

// func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
// これ以外の箇所でtableViewCellを描画する方法

// cellForRowAtIndexPathを利用する
let row: Int
let section: Int
let indexPath = NSIndexPath(forRow: row, inSection: section)
if let cell = tableView?.cellForRowAtIndexPath(indexPath: indexPath) {
    let imageName = like ? "button_like_on" : "button_like_off"
    cell.likeButton.setImage(UIImage(named: imageName), forState: .Normal)
}

// --------------------------------------

// Storyboardを分割した時の遷移方法

// ページ遷移する時に利用する関数をプロトコルにする
protocol StoryboardLoadable: class {
    static var storyboardName: String { get }
}

extension StoryboardLoadable where Self: UIViewController {
    static var storyboardName: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!.stringByReplacingOccurrencesOfString("ViewController", withString: "")
    }
}

// 遷移先のStoryboardに対応するViewControllerをインスタンス化するためのメソッド。あらかじめStoryboardとそれに対応するViewControllerを作成しておく。
// Utilities/Utils.swiftに書くと良い
static func createViewController<T: StoryboardLoadable>() -> T {
    let sb = UIStoryboard(name: T.storyboardName, bundle: nil)
    
    return sb.instantiateInitialViewController() as! T
}

// 利用する時は型を指定する。
let vc: ArticleDetailViewControlelr = Utils.createViewController(self)

// 遷移する時はこんな感じに書く
self.parentNavigationController?.pushViewController(vc, animated: true)


// --------------------------------------

// 画像を切り替える方法
// 切り替える画像を二つ準備してAssets.xcassetsに登録しておく。
// setImageする先に注意。customView.setImageではない。階層を確認する。
var isLike: Bool
let imageName = isLike ? "imageNameBefore" : "imageNameAfter"
costumView.likeButton.setImage(UIImage(named: imageName), forState: .Normal)

// --------------------------------------

// 自作delegateの活用
// 使いどころ：他クラスのプロパティ等を扱いたい時。例えば、カスタムビューをタップした時に、親である（SNSShareCellの呼び出し元の）ViewControllerのプロパティを変更するとか。
// ここではArticleDetailViewControllerの記事の下にあるFacebookButton（SNSShareCell.swift）をタップするとArticleDetailViewControllerのarticle.idに関連する記事をシェアできるようにする。delegateを使わないとarticle.idをSNSShareCell.swiftで利用できない。

// 子供: SNSShareCell.swift、親: ArticleDetailViewController.swiftとする
// 手順1: protocolの準備（基本子供的なイメージの方に書くと思えば良い）
// 手順2: weak var delegate: ShareActionDelegate? と作成したdelegateのインスタンスを宣言（子供側）。これのおかげで親側と子供側の関連付けを可能にできる
// 手順3: 親側に自作protocolを継承させる
// 手順4: 親側で子供のdelegateプロパティ（手順2のやつ）にself（ArticleDetailViewContoller）を設定する（親と子供の関連付け）。SNSShareCellを描画してから設定しないといけない
// 手順5: 子供側で使いたいメソッドを親側で書く（tapするとarticleをlike保存する）。親側で実装することで親側にしかないプロパティを子供で利用できたりできる。
// 手順6: protocolに手順5で作成したメソッド名を書く
// 手順7: delegate?.shareAction(serviceType: SLServiceTypeTwitter) と子供側でdelegateメソッドを利用する
// 実装の手順はSNSShareCell.swift => ArticleDetailViewController.swift => SNSShareCell.swiftとなるのに注意


// SNSShareCell.swift（子供的なイメージ）

import UIKit
import Social

protocol ShareActionDelegate: class {// 手順1
    func shareAction(serviceType type: String)// 手順6
}

class SNSShareCell: ArticleItemViewCell {
    
    weak var delegate: ShareActionDelegate? // 手順2

    @IBAction func twitterTapAction(sender: AnyObject) {
        delegate?.shareAction(serviceType: SLServiceTypeFacebook)// 手順7
    }
}


// ArticleDetailViewController.swift（親的なイメージ）

class ArticleDetailViewController: ViewController {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customView: SNSShareCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        customView.delegate = self // 手順4
        // その他のコード
    }

    extension ArticleDetailViewController: ShareActionDelegate {// 手順3
        func shareAction(serviceType type: String) { //手順5
            let text = self.article.title
            let id = self.article.id ?? 0
            let url = "http://topicks.jp/" + String(id) + "?from=marble_ios"
            let shareWebsite = NSURL(string: url)!
        
            let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: type)!
            composeViewController.setInitialText(text)
            composeViewController.addURL(shareWebsite)
            self.presentViewController(composeViewController, animated: true, completion: nil)
        }
    }
}

// --------------------------------------

// 上のようなクラス横断的なやりとりはハンドラを使っても記述できる。自作ハンドラの使い方

// SNSShareCell.swift

// 手順1: 子供側で空のクロージャーを定義する。名前をshareActionとしておく
// 手順2: 親側でshareActionの実装をする
// 手順3: 子供側でtapしたときにshareActionを呼ぶように設定する

class SNSShareCell: ArticleItemViewCell {
    
    var shareAction: (String) -> Void = { _ in } // 手順1
    
    @IBAction func fbTapAction(sender: AnyObject) {// 手順3
        shareAction(SLServiceTypeFacebook)
    }

}

// ArticleDetaiViewController.swift

class ArticleDetailViewController: ViewController {

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let customView: ShareContainerView = Utils.createView(self)
            // 手順2
            customView.shareAction = { [weak self] serviceType in
                guard let `self` = self else { return }
                let text = self.article.title
                let id = self.article.id ?? 0
                let url = "http://topicks.jp/" + String(id) + "?from=marble_ios"
                let shareWebsite = NSURL(string: url)!
            
                let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: serviceType)!
                composeViewController.setInitialText(text)
                composeViewController.addURL(shareWebsite)
                self.presentViewController(composeViewController, animated: true, completion: nil)
            }
            return customView
        }
        return nil
    }
}

// --------------------------------------
// --------------------------------------
// --------------------------------------
// --------------------------------------
// --------------------------------------
// --------------------------------------
// --------------------------------------















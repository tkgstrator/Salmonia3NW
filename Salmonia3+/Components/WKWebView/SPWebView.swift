//
//  SPWebView.swift
//  AnimatableShape
//
//  Created by tkgstrator on 2022/10/20.
//

import Foundation
import SwiftUI
import WebKit
import Common
import Alamofire
#if !os(macOS)
import UIKit
import SplatNet3
import SDBridgeSwift
#endif

struct SPWebView: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        var parent: SPWebView

        init(_ parent: SPWebView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> SPWebView.Coordinator {
        SPWebView.Coordinator(self)
    }

    /// 実質イニシャライザと同様の役割を持っている
    func makeUIViewController(context: Context) -> WebViewController {
        let webview = WebViewController(coordinator: context.coordinator)
        return webview
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
    }
}

private enum NSScriptContent {
    case closeWebView
    case reloadExtension
    case completeLoading
    case invokeNativeShare(Share)
    case invokeNativeShareUrl(ShareURL)
    case copyToClipboard(String)
    case downloadimages([String])

    struct Share: Codable {
        let text: String
        let imageUrl: String
        let hashtags: [String]
    }
    struct ShareURL: Codable {
        let text: String
        let url: String
    }
}

/// イカリング3が送ってくるメッセージ
private enum NSScriptMessage: String, CaseIterable {
    case closeWebView
    case reloadExtension
    case completeLoading
    case invokeNativeShare
    case invokeNativeShareUrl
    case copyToClipboard
    case downloadimages
}

final class WebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    @Environment(\.locale) var locale
    @StateObject var session: Session = Session()
    let bridge: WebViewJavascriptBridge

    private let webView: WKWebView = {
        let webView: WKWebView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor(SPColor.SplatNet3.SPBackground)
        return webView
    }()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
//        indicator.style = .large
        indicator.color = .white
        return indicator
    }()

    private func evaluateJavaScript(content: Any?) {
        /// 変換不能だったとき
        guard let content = content,
              let stringValue = content as? String
        else {
            return
        }

        /// 単一メッセージ
        if let message: NSScriptMessage = NSScriptMessage(rawValue: stringValue) {
            switch message {
                case .closeWebView:
                    UIApplication.shared.rootViewController?.dismiss(animated: true)
                default:
                    break
            }
            return
        }

        /// メッセージデータを取得
        guard let data: Data = stringValue.data(using: .utf8) else {
            return
        }

        /// デコーダー
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        /// 共有
        if let object: NSScriptContent.Share = try? decoder.decode(NSScriptContent.Share.self, from: data) {
            let session: Alamofire.Session = Alamofire.Session()
            Task {
                guard let data: Data = try? await session.download(URL(unsafeString: object.imageUrl)).serializingData().value,
                      let image: UIImage = UIImage(data: data)
                else {
                    return
                }
                let ac: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                self.present(ac, animated: true)
            }
            return
        }

        /// URL共有
        if let object: NSScriptContent.ShareURL = try? decoder.decode(NSScriptContent.ShareURL.self, from: data) {
            let items: [Any] = [
                "\(object.text) #Salmonia3",
                URL(unsafeString: object.url)
            ]
            let ac: UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
            return
        }

        /// クリップボードにコピー
        if let code: String = stringValue.capture(pattern: #"([A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4})"#, group: 1) {
            UIPasteboard.general.string = code
        }

        if let imageURL: String = stringValue.capture(pattern: #"\[(https://.*)\]"#, group: 1) {
            Task {
                let session: Alamofire.Session = Alamofire.Session()
                guard let data: Data = try? await session.download(URL(unsafeString: imageURL)).serializingData().value,
                      let image: UIImage = UIImage(data: data)
                else {
                    return
                }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }

    init(coordinator: SPWebView.Coordinator) {
        self.bridge = WebViewJavascriptBridge(webView: self.webView)
        super.init(nibName: nil, bundle: nil)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.view = webView

        bridge.consolePipeClosure = { content in
            self.evaluateJavaScript(content: content)
        }

        // This register for javascript call
        bridge.register(handlerName: "DeviceLoadJavascriptSuccess") { (parameters, callback) in
            let data = ["result":"iOS"]
            callback?(data)
        }

        self.loadRequest()
    }

    required init?(coder: NSCoder) {
        self.bridge = WebViewJavascriptBridge(webView: WKWebView())
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.center = self.view.center
        self.indicator.startAnimating()
        self.view.addSubview(indicator)
    }

    /// This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
    override func loadView() {
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }

    /// リクエスト前に呼ばれる
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("リクエスト前")

        /*
         * WebView内の特定のリンクをタップした時の処理などが書ける(2019/11/16追記)
         */
        let url = navigationAction.request.url
        print("読み込もうとしているページのURLが取得できる: ", url ?? "")
        // リンクをタップしてページを読み込む前に呼ばれるので、例えば、urlをチェックして
        // ①AppStoreのリンクだったらストアに飛ばす
        // ②Deeplinkだったらアプリに戻る
        // みたいなことができる

        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
    }

    /// 読み込み準備開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("読み込み準備開始")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
        self.indicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗検知")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation: WKNavigation!) {
        print("リダイレクト")
    }

    /// ロードする
    private func loadRequest() {
        guard let account = session.account,
              let gameWebToken: JWT = try? JWT(gameWebToken: account.credential.gameWebToken)
        else {
            return
        }
        let gtoken: String = account.credential.gameWebToken

        switch gameWebToken.status {
            case .Valid:
                self.loadWithGToken(gtoken: gtoken)
            case .Expired:
                session.refresh(account.credential, for: Alamofire.Session(), completion: { value in
                    switch value {
                        case .success(let credential):
                            let gtoken: String = credential.gameWebToken
                            self.loadWithGToken(gtoken: gtoken)
                        case .failure(_):
                            break
                    }
                })
        }
    }

    /// GTokenを利用してイカリング3を読み込む
    private func loadWithGToken(gtoken: String) {
        print(gtoken)
        var baseURL: URL = URL(unsafeString: "https://api.lp1.av5ja.srv.nintendo.net/")

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lang", value: Locale.languageSP3Code)
        ]
        baseURL.queryItems(queryItems)
        let request: URLRequest = URLRequest(url: baseURL)
        let config: WKWebViewConfiguration = WKWebViewConfiguration()

        DispatchQueue.main.async(execute: {
            /// Cookieの設定
            let cookie = HTTPCookie(properties: [
                HTTPCookiePropertyKey.name: "_gtoken",
                HTTPCookiePropertyKey.value: gtoken,
                HTTPCookiePropertyKey.domain: URL(string: "https://api.lp1.av5ja.srv.nintendo.net/")!.host!,
                HTTPCookiePropertyKey.path: "/"])!
            config.websiteDataStore.httpCookieStore.setCookie(cookie) { [weak self] in
                guard let self = self else { return }
                self.webView.load(request)
            }
        })
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }

}

struct SPWebView_Previews: PreviewProvider {
    static let request: URLRequest = URLRequest(url: URL(string: "https://api.lp1.av5ja.srv.nintendo.net/coop")!)
    //    static let request: URLRequest = URLRequest(url: URL(string: "https://app.splatoon2.nintendo.net/coop")!)

    static var previews: some View {
        SPWebView()
            .preferredColorScheme(.dark)
        //            .ignoresSafeArea()
    }
}

extension URL {
    mutating func queryItems(_ items: [URLQueryItem])  {
        guard var request: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return
        }
        request.queryItems = items
        guard let url: URL = request.url else {
            return
        }
        self = url
    }
}

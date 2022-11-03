//
//  SPWebView.swift
//  AnimatableShape
//
//  Created by devonly on 2022/10/20.
//

import Foundation
import SwiftUI
import WebKit
import Common
import Alamofire
#if !os(macOS)
import UIKit
import SplatNet3
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

/// イカリング3が送ってくるメッセージ
private enum NSScriptMessage: String, CaseIterable {
    case closeWebView
    case reloadExtension
    case completeLoading

    init?(message: WKScriptMessage) {
        guard let rawValue: String = message.body as? String else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
}

final class WebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    @Environment(\.locale) var locale
    @StateObject var session: Session = Session()

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


    init(coordinator: SPWebView.Coordinator) {
        super.init(nibName: nil, bundle: nil)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.view = webView

        /// トークンが設定されていなければ取得不可なのでリターンする
        guard let gtoken = session.account?.credential.gameWebToken
        else {
            UIApplication.shared.rootViewController?.dismiss(animated: true)
            return
        }
        self.loadRequest()
        print("Initialize", self.view.frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad", self.view.frame)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear", self.view.frame)
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear", self.view.frame)
        super.viewWillAppear(animated)
        indicator.center = self.view.center
        self.indicator.startAnimating()
        self.view.addSubview(indicator)
    }

    /// This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
    override func loadView() {
        print("WKWebViewLoad", self.view.frame)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name, message.body)
        guard let message: NSScriptMessage = NSScriptMessage(message: message) else {
            return
        }

        switch message {
            case .closeWebView:
                UIApplication.shared.rootViewController?.dismiss(animated: true)
            case .reloadExtension:
                break
            case .completeLoading:
                break
        }
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

        /// Console.Logをキャッチする
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        DispatchQueue.main.async(execute: {
            let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            self.webView.configuration.userContentController.addUserScript(script)
            self.webView.configuration.userContentController.add(self, name: "logHandler")
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

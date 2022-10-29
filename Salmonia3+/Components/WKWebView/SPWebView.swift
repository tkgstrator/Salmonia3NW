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
    @StateObject var session: Session = Session()

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        var parent: SPWebView

        init(_ parent: SPWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webView.isHidden = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                webView.isHidden = false
            })
        }

        /// エラーが発生したら自動で閉じる
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            UIApplication.shared.rootViewController?.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> SPWebView.Coordinator {
        SPWebView.Coordinator(self)
    }

    func makeUIViewController(context: Context) -> WebViewController {
        let wvc = WebViewController(coordinator: context.coordinator)
        wvc.loadRequest()
        return wvc
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
    }
}

final class WebViewController: UIViewController, WKScriptMessageHandler {
    @Environment(\.locale) var locale
    enum NSScriptMessage: String, CaseIterable {
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

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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

    var webView: WKWebView

    public var delegate: SPWebView.Coordinator? = nil

    init(coordinator: SPWebView.Coordinator) {
        self.delegate = coordinator
        self.webView = WKWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.webView = WKWebView()
        super.init(coder: coder)
    }

    public func loadRequest() {
        guard let delegate = delegate,
              let account = delegate.parent.session.account,
              let gameWebToken: JWT = try? JWT(gameWebToken: account.credential.gameWebToken)
        else {
            return
        }

        let gtoken: String = account.credential.gameWebToken

        switch gameWebToken.status {
        case .Valid:
            self.loadWithGToken(gtoken: gtoken)
        case .Expired:
            delegate.parent.session.refresh(account.credential, for: Alamofire.Session(), completion: { value in
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

    private func loadWithGToken(gtoken: String) {
        var baseURL: URL = URL(unsafeString: "https://api.lp1.av5ja.srv.nintendo.net/")

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lang", value: Locale.languageSP3Code),
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

    override func loadView() {
        self.webView.navigationDelegate = self.delegate
        self.webView.uiDelegate = self.delegate
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

//
//  DebugView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/21.
//

import SwiftUI

struct DebugView: View {
    @StateObject var session: Session = Session()
    @AppStorage("IS_DEBUG_ERROR_SESSION") var lists: [Bool] = Array(repeating: false, count: SPEndpoint.allCases.count)
    @AppStorage("IS_DEBUG_FORCE_FETCH") var isForceFetch: Bool = false
    @State private var isPresented: Bool = false

    var body: some View {
        List(content: {
            Section(content: {
                ForEach(SPEndpoint.allCases.dropLast()) { errorType in
                    Toggle(isOn: Binding(get: {
                        if let index: Int = SPEndpoint.allCases.firstIndex(of: errorType) {
                            return lists[index]
                        }
                        return false
                    }, set: { newValue in
                        if let index: Int = SPEndpoint.allCases.firstIndex(of: errorType) {
                            lists[index] = newValue
                        }
                    }), label: {
                        Text(errorType.rawValue)
                    })
                }
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("ログインテスト")
                })
                .disabled(session.isPopuped)
                .authorize(isPresented: $isPresented, session: session)
            }, header: {
                Text("エラーテスト")
            })
            Section(content: {
                Toggle(isOn: $isForceFetch, label: {
                    Text("リザルト強制取得")
                })
            }, header: {
                Text("デバッグモード")
            })
        })
        .onAppear(perform: {
            if lists.count < SPEndpoint.allCases.count {
                lists = Array(repeating: false, count: SPEndpoint.allCases.count)
            }
        })
        .popup(isPresented: $session.isPopuped, view: {
            LoadingView(session: session)
        })
        .navigationTitle(Text("デバッグ"))
    }
}

enum SPEndpoint: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    case SESSION_TOKEN          = "api/session_token"
    case ACCESS_TOKEN           = "api/token"
    case F                      = "f"
    case SPLATOON_TOKEN         = "v3/Account/Login"
    case SPLATOON_ACCESS_TOKEN  = "v2/Game/GetWebServiceToken"
    case VERSION                = "api/version"
    case WEB_VERSION            = "lookup"
    case BULLET_TOKEN           = "api/bullet_tokens"
    case COOP_SUMMARY           = "api/summary"
    case COOP_RESULT            = "api/results"
    case UNKNOWN                = "unknown"
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
            .preferredColorScheme(.dark)
    }
}

//
//  DebugView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/21.
//

import SwiftUI
import Common
import SplatNet3

struct DebugView: View {
    @StateObject var session: Session = Session()
    @AppStorage("IS_DEBUG_ERROR_SESSION") var lists: [Bool] = Array(repeating: false, count: SPEndpoint.allCases.count)
    @AppStorage("IS_DEBUG_FORCE_FETCH") var isForceFetch: Bool = false
    @AppStorage("IS_DEBUG_DONOT_WRITE") var isWritable: Bool = false
    @AppStorage("IS_DEBUG_MAX_FETCH_COUNTS") var maxFetchCounts: Double = 50

    @State private var isPresented: Bool = false
    @State private var isPopuped: Bool = false
    let formatter: ISO8601DateFormatter = ISO8601DateFormatter()

    var body: some View {
        List(content: {
            Section(content: {
                if let account: UserInfo = session.account {
                    HStack(content: {
                        Text("アカウント名")
                        Spacer()
                        Text(account.nickname)
                    })
                    HStack(content: {
                        Text("有効期限")
                        Spacer()
                        Text(formatter.string(from: account.credential.expiration))
                    })
                    Button(action: {
                        do {
                            try session.resetExpiresIn()
                            session.objectWillChange.send()
                        } catch(let error) {
                            print(error)
                        }
                    }, label: {
                        Text("トークンの有効期限リセット")
                    })
                }
            }, header: {
                Text("アカウント情報")
            })
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
                    Text("ログイン")
                })
            }, header: {
                Text("エラー")
            })
            Section(content: {
                Toggle(isOn: $isForceFetch, label: {
                    Text("リザルト強制取得")
                })
                HStack(content: {
                    Text("最大取得件数")
                    Spacer()
                    Slider(value: $maxFetchCounts, in: 0...50, step: 1)
                    Text("\(Int(maxFetchCounts))")
                })
                Toggle(isOn: $isWritable, label: {
                    Text("リザルトを書き込まない")
                })
            }, header: {
                Text("追加コマンド")
            })
        })
        .onAppear(perform: {
            if lists.count < SPEndpoint.allCases.count {
                lists = Array(repeating: false, count: SPEndpoint.allCases.count)
            }
        })
        .navigationTitle(Text("追加機能"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum SPEndpoint: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    case SESSION_TOKEN          = "api/session_token"
    case ACCESS_TOKEN           = "api/token"
    case F                      = "f"
    case SPLATOON_TOKEN         = "v3/Account/Login"
    case SPLATOON_ACCESS_TOKEN  = "v2/Game/GetWebServiceToken"
    case VERSION                = "lookup"
    case WEB_VERSION            = "api/web_version"
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

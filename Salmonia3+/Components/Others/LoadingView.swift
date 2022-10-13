//
//  LoadingView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import SplatNet3
import SDWebImageSwiftUI

struct LoadingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var session: Session = Session()
    @Binding var code: String?
    @Binding var verifier: String?
    let onSuccess: () -> Void

    init(code: Binding<String?>, verifier: Binding<String?>, onSuccess: @escaping () -> Void) {
        self._code = code
        self._verifier = verifier
        self.onSuccess = onSuccess
    }

    var body: some View {
        VStack(content: {
            ForEach(session.loginProgress) { progress in
                HStack(content: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 60, height: 24, alignment: .center)
                        .foregroundColor(progress.color)
                        .overlay(Text(progress.apiType.rawValue).foregroundColor(.white))
                    Text(progress.path.rawValue)
                        .frame(width: 220, height: nil, alignment: .leading)
                        .lineLimit(1)
                    switch progress.progressType {
                    case .PROGRESS:
                        ProgressView()
                            .frame(width: 24, height: 24, alignment: .center)
                    case .FAILURE:
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.red)
                    case .SUCCESS:
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.green)
                    }
                })
            }
        })
        .padding(EdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 12))
        .background(SPColor.Theme.SPTheme.cornerRadius(12))
        .padding(.horizontal, 40)
        .animation(.default, value: session.loginProgress.count)
        .onAppear(perform: {
            if let code = code, let verifier = verifier {
                Task {
                    do {
                        try await session.getCookie(code: code, verifier: verifier)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            onSuccess()
                            session.loginProgress.removeAll()
                            dismiss()
                        })
                    } catch {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            // ログインが失敗したらすべてのデータを消去
                            session.loginProgress.removeAll()
                            dismiss()
                        })
                    }
                }
            }
        })
    }
}
//
//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}

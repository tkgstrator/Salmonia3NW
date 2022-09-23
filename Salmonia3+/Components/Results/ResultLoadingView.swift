//
//  ResultLoadingView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import SDWebImageSwiftUI
import SplatNet3

struct ResultLoadingView: View {
    @StateObject var session: Session = Session()
    @Environment(\.isModalPopuped) var isModalPopuped

    var body: some View {
        VStack(content: {
            ForEach(session.loginProgress) { progress in
                HStack(content: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 60, height: 24, alignment: .center)
                        .foregroundColor(progress.color)
                        .overlay(Text(progress.apiType.rawValue))
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
            ZStack(content: {
                Circle()
                    .stroke(.gray, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: session.resultCountsNum == 0 ? 0 : CGFloat(session.resultCounts) / CGFloat(session.resultCountsNum))
                    .stroke(.pink, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                VStack(alignment: .center, spacing: 0, content: {
                    WebImage(loading: .SPLATNET2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60, alignment: .center)
                    Text("\(String(format: "%02d", session.resultCounts))/\(String(format: "%02d", session.resultCountsNum))")
                        .animation(nil)
                        .transition(.identity)
                        .font(systemName: .Splatfont2, size: 18)
                })
            })
            .frame(width: 120, height: 120, alignment: .center)
            .padding()
        })
        .padding(EdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 12))
        .background(SPColor.Theme.SPTheme.cornerRadius(12))
        .padding(.horizontal, 40)
        .onAppear(perform: {
            // スリープモードにならないようにする
            UIApplication.shared.isIdleTimerDisabled = true
            Task {
                // リザルト取得後にモーダルを閉じる
                try await session.getCoopResults()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                isModalPopuped.wrappedValue = false
            })
        })
        .onDisappear(perform: {
            // 処理が終わったのでスリープモード制限解除
            UIApplication.shared.isIdleTimerDisabled = false
        })
    }
}

struct ResultLoadingView_Previews: PreviewProvider {
    @StateObject static var session: Session = Session()
    
    static var previews: some View {
        ResultLoadingView(session: session)
    }
}

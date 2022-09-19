//
//  ResultLoadingView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResultLoadingView: View {
    @StateObject var session: Session
    let baseURL: URL? = URL(unsafeString: "https://cdn.discordapp.com/attachments/883143492623278100/998164048266928198/animated.png")

    var body: some View {
        VStack(content: {
            ForEach(session.loginProgress) { progress in
                HStack(content: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 60, height: 24, alignment: .center)
                        .foregroundColor(progress.color)
                        .overlay(Text(progress.apiType.rawValue))
                    Text(progress.path)
                        .frame(width: 220, height: nil, alignment: .leading)
                        .lineLimit(1)
                    switch progress.progressType {
                    case .progress:
                        ProgressView()
                            .frame(width: 24, height: 24, alignment: .center)
                    case .failure:
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.red)
                    case .success:
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
                    .trim(from: 0, to: CGFloat(session.resultCounts) / CGFloat(session.resultCountsNum))
                    .stroke(.pink, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                WebImage(url: baseURL, isAnimating: .constant(true))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60, alignment: .center)
            })
            .frame(width: 120, height: 120, alignment: .center)
            .padding()
        })
        .padding(EdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 12))
        .background(Color.themeColor.cornerRadius(12))
        .padding(.horizontal, 40)
        .onAppear(perform: {
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .onDisappear(perform: {
            UIApplication.shared.isIdleTimerDisabled = false
        })
    }
}

//struct ResultLoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultLoadingView()
//    }
//}

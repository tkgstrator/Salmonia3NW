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
    @StateObject var session: Session

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
    }
}
//
//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
//
//  StageView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/14
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct StageView: View {
    @ObservedResults(RealmCoopResult.self) var results
    @State private var offset: CGFloat = 0
    @State private var selection: Int = 0
    @State private var headers: [_StageHeaderTab] = [
        .Shakeup,
        .Shakespiral,
        .Shakeship,
        .Shakedent,
    ].map({ _StageHeaderTab(stageId: $0) })


    var body: some View {
        TabView(selection: $selection, content: {
            ForEach(headers, content: { header in
                _StageHeader(header: header)
                    .overlay(content: {
                        GeometryReader(content: { geometry in
                            Color.clear
                                .preference(key: OffsetKey.self, value: geometry.frame(in: .global).minX)
                        })
                    })
                    .onPreferenceChange(OffsetKey.self, perform: { newValue in
                        self.offset = newValue
                    })
                    .tag(getIndex(header: header))
            })
        })
        .onChange(of: offset, perform: { value in
            if selection == 0 && offset == 0 {
                selection = headers.count - 2
            }
            if selection == headers.count - 1 && offset == 0 {
                selection = 1
            }
        })
        .onAppear(perform: {
            if headers.count == 4 {
                guard var first = headers.first,
                      var last = headers.last
                else {
                    return
                }
                first.id = UUID()
                last.id = UUID()
                headers.append(first)
                headers.insert(last, at: 0)

                selection = 1
            }
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .aspectRatio(390/195, contentMode: .fit)
    }

    private func getIndex(header: _StageHeaderTab) -> Int {
        headers.firstIndex(of: header) ?? 0
    }
}

private struct _StageHeaderTab: Identifiable, Hashable {
    var id: UUID = UUID()
    let stageId: CoopStageId
}

private struct _StageHeader: View {
    @StateObject private var stats: StageStats = StageStats()
    let header: _StageHeaderTab

    func MakeBody() -> some View {
        VStack(content: {
            HStack(content: {
                Text(bundle: .Custom_Results_Count)
                Spacer()
                Text(String(format: "x%d", stats.counts))
            })
            HStack(content: {
                Text(bundle: .Custom_Max_Grade)
                Spacer()
                HStack(spacing: 2, content: {
                    Text(stats.maxGrade)
                    Text(String(format: "%d", stats.maxGradePoint))
                })
            })
            HStack(content: {
                Text(bundle: .Custom_Max_Golden_Eggs)
                Spacer()
                Text(String(format: "x%d", stats.maxGoldenIkuraNum))
            })
            HStack(content: {
                Text(bundle: .Custom_Max_Power_Eggs)
                Spacer()
                Text(String(format: "x%d", stats.maxIkuraNum))
            })
        })
        .padding(.all, 14)
        .background(content: {
            Color.black.opacity(0.6)
        })
        .onAppear(perform: {
//            stats.calc(stageId: header.stageId, results: results)
        })
        .font(systemName: .Splatfont2, size: 16)
        .foregroundColor(Color.white)
        .padding(.top, 40)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }

    var body: some View {
        Image(header.stageId, size: .Regular)
            .resizable()
            .scaledToFill()
            .aspectRatio(390/195, contentMode: .fit)
            .overlay(content: {
                Image(layout: .Frame_00)
                    .resizable()
            })
            .overlay(content: {
                MakeBody()
            })
            .overlay(alignment: .top, content: {
                Text(header.stageId)
                    .font(systemName: .Splatfont2, size: 16)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 0)
                    .background(content: {
                        Color.black.opacity(0.85)
                    })
                    .padding(.top, 10)
            })
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            StageView()
        })
    }
}

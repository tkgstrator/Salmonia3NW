//
//  StageView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/14
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct StageView: View {
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
            if selection == 0 && abs(offset) <= 50 {
                selection = headers.count - 2
            }
            if selection == headers.count - 1 && abs(offset) <= 50 {
                selection = 1
            }
        })
        .onAppear(perform: {
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
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .aspectRatio(390/195, contentMode: .fit)
    }

    private func getIndex(header: _StageHeaderTab) -> Int {
        headers.firstIndex(of: header) ?? 0
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct _StageHeaderTab: Identifiable, Hashable {
    var id: UUID = UUID()
    let stageId: CoopStageId
}

private struct _StageHeader: View {
    let header: _StageHeaderTab

    var body: some View {
        Image(header.stageId, size: .Regular)
            .resizable()
            .scaledToFill()
            .frame(width: 390, height: 195)
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}

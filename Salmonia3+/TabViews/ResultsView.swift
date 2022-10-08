//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultsView: View {
    let results: RealmSwift.Results<RealmCoopResult>

    init(results: RealmSwift.List<RealmCoopResult>) {
        self.results = results.sorted(byKeyPath: "playTime", ascending: false)
    }

    var body: some View {
        List(content: {
            ForEach(results) { result in
                NavigationLinker(destination: {
                    ResultDetailView(result: result, schedule: result.schedule)
                }, label: {
                    ResultView(result: result)
                })
            }
        })
        .listStyle(.plain)
        .navigationTitle(Text(bundle: .Record_Title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// リザルトがなにもないときに下スワイプで取得できることを表示する
private struct ResultsEmpty: View {
    @State private var value: CGFloat = 0

    var body: some View {
        GeometryReader(content: { geometry in
            Text("↓")
                .font(systemName: .Splatfont, size: 34)
                .position(x: geometry.center.x, y: 80 + value)
            Text(bundle: .Common_PullToRefresh)
                .font(systemName: .Splatfont, size: 24)
                .multilineTextAlignment(.center)
                .position(x: geometry.center.x, y: 180)
        })
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                value = 50
            }
        })
    }
}

struct ResultsWithScheduleView: View {
    @ObservedResults(
        RealmCoopResult.self,
        filter: NSPredicate(format: "ANY link.mode = %@", ModeType.CoopHistory_Regular.mode),
        sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)
    ) var results
    @StateObject var session: Session = Session()
    @State private var selection: ModeType = ModeType.CoopHistory_Regular
    @State private var isPresented: Bool = false

    var body: some View {
        List(content: {
            ForEach(results) { result in
                NavigationLinker(destination: {
                    ResultTabView(results: results)
                        .environment(\.selection, .constant(result.id))
                }, label: {
                    ResultView(result: result)
                })
            }
        })
        .overlay(results.isEmpty ? AnyView(ResultsEmpty()) : AnyView(EmptyView()), alignment: .center)
        .onChange(of: selection, perform: { newValue in
            $results.filter = NSPredicate(format: "ANY link.mode = %@", selection.mode)
        })
        .refreshable(action: {
            await session.dummy(action: {
                isPresented.toggle()
            })
        })
        .fullScreen(isPresented: $isPresented, content: {
            ResultLoadingView()
                .environment(\.dismissModal, DismissModalAction($isPresented))
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    selection.next()
                }, label: {
                    Image("ButtonType/Update", bundle: .main)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)
                })
            })
        })
        .listStyle(.plain)
        .navigationTitle(Text(mode: selection))
        .navigationBarTitleDisplayMode(.inline)
    }
}

//extension SplatNet2.Rule: AllCaseable {}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}

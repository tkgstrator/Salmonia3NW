//
//  EnemyChart.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/03
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import SwiftUI
import Charts
import SplatNet3
import RealmSwift

enum PlayerCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    /// 個人記録
    case Player     = "Common_Player_You"
    /// チーム記録
    case Team       = "Common_Player_Team"

    var localized: String {
        NSLocalizedString(self.rawValue, bundle: .main, comment: "")
    }
}

enum FormatCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    /// 割合
    case Ratio      = "Common_Format_Ratio"
    /// 数
    case Number     = "Common_Format_Number"

    var localized: String {
        NSLocalizedString(self.rawValue, bundle: .main, comment: "")
    }
}

struct EnemyCount: Identifiable {
    let id: UUID = UUID()
    /// シフト
    let shift: Int
    /// 累計
    let total: Int
}

struct EnemyKillCount: Identifiable {
    let id: UUID = UUID()
    /// 個人
    let solo: Int
    /// チーム
    let team: Int
}

struct EnemyResultEntry: Identifiable {
    /// ID
    var id: UUID = UUID()
    /// スケジュール
    let schedule: RealmCoopSchedule
    /// オオモノID
    let enemyKey: EnemyKey
    /// スケジュールID
    let scheduleId: Date
    /// オオモノ出現数
    let bossCount: EnemyCount
    /// オオモノ討伐数
    let bossKillCount: EnemyKillCount
    /// オオモノ累計討伐数
    let bossKillTotal: EnemyKillCount
}

struct EnemyToggle: Equatable {
    let enemyKey: EnemyKey
    var isPresented: Bool

    internal init(enemyKey: EnemyKey, isPresented: Bool) {
        self.enemyKey = enemyKey
        self.isPresented = isPresented
    }
}

@available(iOS 16.0, *)
extension EnemyKey: Plottable {}

extension Date {
    init(iso8601: String) {
        let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        self.init(timeIntervalSince1970: formatter.date(from: iso8601)?.timeIntervalSince1970 ?? 0)
    }
}

struct EmptySymbol: ChartSymbolShape {
    var perceptualUnitRect: CGRect = .zero

    func path(in rect: CGRect) -> Path {
        .init()
    }
}

struct EnemyChartView: View {
    @State private var location: CGPoint? = nil
    @State private var length: Int = 10
    @State private var enemyResults: [EnemyResultEntry] = []
    @State private var element: EnemyResultEntry? = nil
    @State private var scale: CGFloat = 1
    @State private var enemies: [EnemyToggle] = EnemyKey.allCases.map({ EnemyToggle(enemyKey: $0, isPresented: true) })

    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView(showsIndicators: false, content: {
//                Schedule
//                TypePicker
//                FormatPicker
                EnemyChart
                EnemyList
//                DetailChart
            })
            .listStyle(.plain)
            .onAppear(perform: {
                self.enemyResults = getEnemyResults(limit: length)
            })
        } else {
            EmptyView()
        }
    }

    private func getEnemyResults(limit: Int = 10) -> [EnemyResultEntry] {
        RealmService.shared.schedules(mode: .REGULAR).enemyResults(limit: limit)
    }

//    @available(iOS 16.0, *)
//    private var Schedule: some View {
//        let schedule: RealmCoopSchedule = selectedElement?.schedule ?? RealmCoopSchedule.preview
//        return ScheduleElement(schedule: schedule).asAnyView()
//    }

//    @available(iOS 16.0, *)
//    private var LengthStepper: some View {
//        Stepper(value: $length, in: 5...100, step: 5, label: {
//            Text(length, format: .number)
//        })
//    }
//
//    @available(iOS 16.0, *)
//    private var LengthPicker: some View {
//        HStack(content: {
//            Text("履歴")
//            Spacer()
//            Picker("Type", selection: $length.animation(.easeInOut), content: {
//                ForEach([5, 25, 50, 100], id: \.self, content: { length in
//                    Text(length, format: .number)
//                        .tag(length)
//                })
//            })
//            .pickerStyle(.menu)
//        })
//        .onChange(of: length, perform: { value in
//            UIApplication.shared.startAnimating(completion: {
//                self.enemyResults = getEnemyResults(limit: length)
//            })
//        })
//    }

//    @available(iOS 16.0, *)
//    private var TypePicker: some View {
//        Picker("Type", selection: $action.animation(.easeInOut), content: {
//            ForEach(PlayerCategory.allCases, content: { category in
//                Text(category.localized)
//                    .tag(category)
//            })
//        })
//        .pickerStyle(.segmented)
//    }
//
//    @available(iOS 16.0, *)
//    private var FormatPicker: some View {
//        Picker("Type", selection: $format.animation(.easeInOut), content: {
//            ForEach(FormatCategory.allCases, content: { category in
//                Text(category.localized)
//                    .tag(category)
//            })
//        })
//        .pickerStyle(.segmented)
//    }

    @available(iOS 16.0, *)
    private var EnemyList: some View {
        let entries: [EnemyResultEntry] = {
            if let element = element {
                return enemyResults.filter({ $0.scheduleId == element.scheduleId })
            }
            return []
        }()

        return LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .leading), count: 3), alignment: .leading, content: {
            ForEach(entries, content: { entry in
                let index: Int = enemies.firstIndex(where: { $0.enemyKey == entry.enemyKey }) ?? 0
                Button(action: {
                    withAnimation(.easeInOut) {
                        enemies[index].isPresented.toggle()
                    }
                }, label: {
                    Label(title: {
                        GeometryReader(content: { geometry in
                            ZStack(alignment: .leading, content: {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.primary.opacity(0.3))
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(SPColor.SplatNet3.SPBlue)
                                Text(entry.bossKillCount.solo, format: .number)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 4)
                            })
                        })
                    }, icon: {
                        Image(entry.enemyKey)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    })
                })
                .buttonStyle(.plain)
                .grayscale(enemies[index].isPresented ? 0.0 : 1.0)
            })
        })
    }

    @available(iOS 16.0, *)
    private var EnemyChart: some View {
        let enemies: [EnemyKey] = enemies.filter({ $0.isPresented }).map({ $0.enemyKey })
        let results: [EnemyResultEntry] = enemyResults.filter({ enemies.contains($0.enemyKey) })
        let yMax: Int = results.map({ $0.bossCount.total }).max() ?? 0
        let yMin: Int = results.map({ $0.bossCount.total }).min() ?? 0

        return Chart(enemyResults, content: { entry in
            if enemies.contains(entry.enemyKey) {
                LineMark(
                    x: .value("Schedule", entry.scheduleId),
                    y: .value("Value", entry.bossCount.total)
                )
                .foregroundStyle(by: .value("EnemyId", entry.enemyKey))
                .lineStyle(StrokeStyle(lineWidth: 2.0))
                .interpolationMethod(.cardinal)
                .symbol(symbol: {
                    Image(entry.enemyKey)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                })
            }
        })
        .chartYScale(domain: yMin ... yMax)
        .chartLegend(.hidden)
        .chartForegroundStyleScale([
            EnemyKey.SakelienBomber: SPColor.SplatNet3.SPBlue,
            EnemyKey.SakelienCupTwins: SPColor.SplatNet3.SPCoop,
            EnemyKey.SakelienShield: SPColor.SplatNet3.SPGreen,
            EnemyKey.SakelienSnake: SPColor.SplatNet3.SPXMatch,
            EnemyKey.SakelienTower: SPColor.SplatNet3.SPGesotown,
            EnemyKey.Sakediver: SPColor.SplatNet3.SPBankara,
            EnemyKey.Sakerocket: SPColor.SplatNet3.SPPink,
            EnemyKey.SakePillar: SPColor.SplatNet3.SPSalmonOrangeDarker,
            EnemyKey.SakeDolphin: SPColor.SplatNet3.SPOrange,
            EnemyKey.SakeArtillery: SPColor.SplatNet3.SPSalmonGreen,
            EnemyKey.SakeSaucer: SPColor.SplatNet3.SPRed,
            EnemyKey.SakelienGolden: SPColor.SplatNet3.SPYellow,
            EnemyKey.Sakedozer: SPColor.SplatNet3.SPLeague,
            EnemyKey.SakeBigMouth: SPColor.SplatNet3.SPPrivate,
            EnemyKey.SakelienGiant: .primary,
        ])
        .chartOverlayWithGesture(location: $location, scale: $scale, parameters: { x, y in
            self.element = enemyResults.nearlest(x)
        })
        .chartBackgroundWithGesture(content: { proxy, geometry in
            if let element: EnemyResultEntry = element,
               let interval: DateInterval = Calendar.current.dateInterval(of: .hour, for: element.scheduleId),
               let xValue: CGFloat = proxy.position(forX: interval.start) ?? 0
            {
                let height: CGFloat = geometry[proxy.plotAreaFrame].maxY

                let entries: [EnemyResultEntry] = enemyResults.filter({ $0.scheduleId == element.scheduleId })
                Rectangle()
                    .fill(.red)
                    .frame(width: 2, height: height)
                    .position(x: xValue, y: height * 0.5)
            }
        })
        .frame(height: 300)
        .padding([.leading, .top])
    }

//    func findElement(_ axis: Axis, location: CGPoint) -> EnemyResultEntry? {
//    }
//    @available(iOS 16.0, *)
//    private var DetailChart: some View {
//        Chart(detailResults, content: { entry in
//            let value: Double = entry.getDetailValue(action, format)
//            if value != .zero {
//                BarMark(
//                    x: .value("Value", value),
//                    y: .value("EnemyId", entry.enemyKey.localized)
//                )
//                .foregroundStyle(by: .value("EnemyId", entry.enemyKey))
//                .annotation(position: .overlay, alignment: .trailing, spacing: nil, content: {
//                    let Annotation: Text = {
//                        switch format {
//                        case .Ratio:
//                            return Text(Double(action == .Player ? entry.bossKillCount.solo : entry.bossKillCount.team) / Double(entry.bossCount.shift), format: .percent)
//                        case .Number:
//                            return Text(value, format: .number)
//                        }
//                    }()
//                    Annotation
//                        .font(.footnote)
//                        .foregroundColor(.white)
//                        .fontWeight(.bold)
//                })
//                .annotation(position: .trailing, alignment: .trailing, spacing: nil, content: {
//                    let Annotation: Text = {
//                        switch format {
//                        case .Ratio:
//                            switch action {
//                            case .Player:
//                                return Text(entry.bossKillCount.solo, format: .number)
//                            case .Team:
//                                return Text(entry.bossKillCount.team, format: .number)
//                            }
//                        case .Number:
//                            return Text(Double(action == .Player ? entry.bossKillCount.solo : entry.bossKillCount.team) / Double(entry.bossCount.shift), format: .percent)
//                        }
//                    }()
//                    Annotation
//                        .font(.footnote)
//                        .foregroundColor(.white)
//                        .fontWeight(.bold)
//                })
//            }
//        })
//        .chartLegend(.hidden)
//        .chartXAxis(.hidden)
//        .chartOverlay(content: { proxy in
//            GeometryReader(content: { geometry in
//                Rectangle().fill(.clear).contentShape(Rectangle())
//                    .gesture(SpatialTapGesture().onEnded({ value in
//                        guard let element: EnemyResultEntry = findYElement(location: value.location, proxy: proxy, geometry: geometry) else {
//                            return
//                        }
//                        print(element.enemyKey)
//                    }))
//            })
//        })
//        .frame(height: CGFloat(detailResults.filter({ $0.bossCount.shift != 0 }).count * 40))
//    }

//    @available(iOS 16.0, *)
//    private func findYElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> EnemyResultEntry? {
//        let relativeYPosition: CGFloat = location.y - geometry[proxy.plotAreaFrame].origin.y
//        if let date: Date = proxy.value(atY: relativeYPosition) as Date? {
//            var minDistance: TimeInterval = .infinity
//            var index: Int? = nil
//            for currentIndex in enemyResults.indices {
//                let distance = enemyResults[currentIndex].scheduleId.distance(to: date)
//                if abs(distance) < minDistance {
//                    minDistance = abs(distance)
//                    index = currentIndex
//                }
//            }
//
//            if let index {
//                return enemyResults[index]
//            }
//        }
//        return nil
//    }

//    @available(iOS 16.0, *)
//    private func findXElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> EnemyResultEntry? {
//        let relativeXPosition: CGFloat = location.x - geometry[proxy.plotAreaFrame].origin.x
//        if let date: Date = proxy.value(atX: relativeXPosition) as Date? {
//            var minDistance: TimeInterval = .infinity
//            var index: Int? = nil
//            for currentIndex in enemyResults.indices {
//                let distance = enemyResults[currentIndex].scheduleId.distance(to: date)
//                if abs(distance) < minDistance {
//                    minDistance = abs(distance)
//                    index = currentIndex
//                }
//            }
//
//            if let index {
//                return enemyResults[index]
//            }
//        }
//        return nil
//    }
}

@available(iOS 16.0, *)
extension View {
    /// チャートのタップしたところの座標を返す
    func chartOverlayWithGesture<H: Plottable, V: Plottable>(
        location: Binding<CGPoint?>,
        scale: Binding<CGFloat> = .constant(1.0),
        horizontal: H.Type = Date.self,
        vertical: V.Type = Double.self,
        parameters: @escaping ((H, V) -> Void)
    ) -> some View {
        self.chartOverlay(content: { proxy in
            GeometryReader(content: { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
//                    .gesture(MagnificationGesture()
//                        .onChanged({ value in
//                            scale.wrappedValue = max(1.0, min(5.0, value.magnitude))
//                        }))
                    .gesture(SpatialTapGesture()
                        .onEnded({ value in
                            let origin: CGPoint = geometry[proxy.plotAreaFrame].origin
                            let value: CGPoint = CGPoint(
                                x: value.location.x - origin.x,
                                y: value.location.y - origin.y
                            )
                            location.wrappedValue = value
                            if let xValue: H = proxy.value(atX: value.x),
                               let yValue: V = proxy.value(atY: value.y)
                            {
                                parameters(xValue, yValue)
                            }
                        })
                            .exclusively(
                                before: DragGesture()
                                    .onChanged({ value in
                                        let origin: CGPoint = geometry[proxy.plotAreaFrame].origin
                                        let value: CGPoint = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        location.wrappedValue = value
                                        if let xValue: H = proxy.value(atX: value.x),
                                           let yValue: V = proxy.value(atY: value.y)
                                        {
                                            parameters(xValue, yValue)
                                        }
                                    }))
                    )
            })
        })
    }

    func chartBackgroundWithGesture<Content: View>(
        @ViewBuilder content: @escaping ((ChartProxy, GeometryProxy) -> Content)
    ) -> some View {
        self.chartBackground(content: { proxy in
            ZStack(content: {
                GeometryReader(content: { geometry in
                    content(proxy, geometry)
                })
            })
        })
    }
}

extension Array where Element == EnemyResultEntry {
    func nearlest(_ date: Date) -> Element? {
        /// スケジュールIDのセットを取得
        let scheduleIds: Set<Date> = Set(self.map({ $0.scheduleId }))
        /// 距離が最も小さい最初のエレメントを選択
        guard let scheduleId: Date = scheduleIds.sorted(by: { abs($0.distance(to: date)) < abs($1.distance(to: date)) }).first,
              let entry: Element = self.first(where: { $0.scheduleId == scheduleId })
        else {
            return nil
        }
        return entry
    }
}

extension EnemyResultEntry {
//    func bossKillRatio(_ category: PlayerCategory) -> CGFloat {
//        switch category {
//        case .Player:
//            return
//        case .Team:
//            <#code#>
//        }
//    }

    /// 累計
    func getValue(_ category: PlayerCategory, _ format: FormatCategory) -> Double {
        switch (category, format) {
        case (.Player, .Number):
            return Double(self.bossKillTotal.solo)
        case (.Player, .Ratio):
            return Double(self.bossKillTotal.solo) / Double(self.bossCount.total) * 100
        case (.Team, .Number):
            return Double(self.bossKillTotal.team)
        case (.Team, .Ratio):
            return Double(self.bossKillTotal.team) / Double(self.bossCount.total) * 100
        }
    }

    /// シフトあたり
    func getDetailValue(_ category: PlayerCategory, _ format: FormatCategory) -> Double {
        switch (category, format) {
        case (.Player, .Number):
            return Double(self.bossKillCount.solo)
        case (.Player, .Ratio):
            return Double(self.bossKillCount.solo)
//            return Double(self.bossKillCount.solo) / Double(self.bossCount.total) * 100
        case (.Team, .Number):
            return Double(self.bossKillCount.team)
        case (.Team, .Ratio):
            return Double(self.bossKillCount.team)
//            return Double(self.bossKillCount.team) / Double(self.bossCount.total) * 100
        }
    }
}

extension Array where Element == RealmCoopSchedule {
    func enemyResults(limit: Int) -> [EnemyResultEntry] {
        /// オオモノ出現数
        var bossTotal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var bossKillTotal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var bossTeamKillTotal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

        return self.flatMap({ schedule -> [EnemyResultEntry] in
            /// 累計オオモノ出現数
            bossTotal.add(schedule.bossCounts)
            bossKillTotal.add(schedule.bossKillCounts)
            bossTeamKillTotal.add(schedule.teamBossKillCounts)

            guard let startTime: Date = schedule.startTime,
                  let index: Int = self.lastIndex(of: schedule)
            else {
                return []
            }
            if index < self.count - limit {
                return []
            }

            /// チャートのエントリーを返す
            return zip(EnemyKey.allCases, bossTotal, bossKillTotal, bossTeamKillTotal).map({ enemyKey, bossCount, bossKillCount, teamBossKillCount -> EnemyResultEntry in
                let index: Int = EnemyKey.allCases.firstIndex(of: enemyKey) ?? 0
                return EnemyResultEntry(
                    schedule: schedule,
                    enemyKey: enemyKey,
                    scheduleId: startTime,
                    bossCount: EnemyCount(shift: schedule.bossCounts[index], total: bossCount),
                    bossKillCount: EnemyKillCount(solo: schedule.bossKillCounts[index], team: schedule.teamBossKillCounts[index]),
                    bossKillTotal: EnemyKillCount(solo: bossKillCount, team: teamBossKillCount)
                )
            })
        })
    }
}

extension RealmCoopSchedule {
    /// スケジュールでの各オオモノ出現数合計
    var bossCounts: [Int] {
        self.results.map({ Array($0.bossCounts).prefix(14) + [$0.bossId == nil ? 0 : 1] }).sum()
    }

    /// スケジュールでのメンバーの各オオモノ討伐数合計
    var teamBossKillCounts: [Int] {
        self.results.map({ Array($0.bossKillCounts).prefix(14) + [$0.isBossDefeated == true ? 1 : 0] }).sum()
    }

    /// スケジュールでの各オオモノ討伐数合計
    var bossKillCounts: [Int] {
        self.results.compactMap({ result -> [Int] in
            let bossKillCounts: [Int] = {
                guard let player = result.players.first else {
                    return Array(repeating: 0, count: 15)
                }
                return Array(player.bossKillCounts.dropLast(1)) + [result.isBossDefeated == true ? 1 : 0]
            }()
            return bossKillCounts
        }).sum()
    }
}

extension GeometryProxy {
    var center: CGPoint {
        CGPoint(x: self.frame(in: .local).midX, y: self.frame(in: .local).midY)
    }
}

struct EnemyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyChartView()
    }
}

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

enum EnemyResultCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    /// 個人記録
    case Shift      = "Player"
    /// チーム記録
    case Team       = "Team"
    //    / 個人累計
    //    case Total      = "Total"
    //    case Appear     = "Appear"
}

struct EnemyResultEntry: Identifiable {
    /// ID
    var id: Date { scheduleId }
    /// スケジュール
    let schedule: RealmCoopSchedule
    /// オオモノID
    let enemyKey: EnemyKey
    /// スケジュールID
    let scheduleId: Date
    /// 累計の出現数
    let bossCount: Int
    /// シフトあたりの討伐数
    let bossKillCount: Int
    /// プレイヤーの累計の討伐数
    let bossKillCountTotal: Int
    /// チームの累計の討伐数
    let teamBossKillCount: Int
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
    @State private var selectedElement: EnemyResultEntry? = nil
    @State private var enemyResults: [EnemyResultEntry] = []
    @State private var detailResults: [EnemyResultEntry] = []
    @State private var action: EnemyResultCategory = .Shift

    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView(showsIndicators: false, content: {
                Schedule
                TypePicker
                EnemyChart
                DetailChart
            })
            .listStyle(.plain)
            .onAppear(perform: {
                self.enemyResults = getEnemyResults(limit: 5)
            })
        } else {
            EmptyView()
        }
    }

    private func getEnemyResults(limit: Int = 10) -> [EnemyResultEntry] {
        RealmService.shared.schedules(mode: .REGULAR).enemyResults(limit: limit)
    }

    @available(iOS 16.0, *)
    private var Schedule: some View {
        let schedule: RealmCoopSchedule = selectedElement?.schedule ?? RealmCoopSchedule.preview
        return ScheduleElement(schedule: schedule).asAnyView()
    }

    @available(iOS 16.0, *)
    private var TypePicker: some View {
        Picker("Type", selection: $action.animation(.easeInOut), content: {
            ForEach(EnemyResultCategory.allCases, content: { category in
                Text(category.rawValue)
                    .tag(category)
            })
        })
        .pickerStyle(.segmented)
    }

    @available(iOS 16.0, *)
    private var EnemyChart: some View {
        Chart(enemyResults, content: { entry in
            LineMark(
                x: .value("Schedule", entry.scheduleId),
                y: .value("Value", entry.getValue(action))
            )
            .foregroundStyle(by: .value("EnemyId", entry.enemyKey))
            .accessibilityLabel(entry.scheduleId.formatted(date: .complete, time: .omitted))
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .foregroundStyle(Color.blue.gradient)
            .interpolationMethod(.cardinal)
            .symbol(by: .value("Symbol", entry.enemyKey))
            .symbolSize(60)
        })
        .chartLegend(.hidden)
        .chartOverlay(content: { proxy in
            GeometryReader(content: { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded({ value in
                                guard let element = findElement(location: value.location, proxy: proxy, geometry: geometry) else {
                                    return
                                }
                                if selectedElement?.scheduleId == element.scheduleId {
                                    selectedElement = nil
                                } else {
                                    self.detailResults = enemyResults.filter({ $0.scheduleId == element.scheduleId })
                                    selectedElement = element
                                }
                            })
                            .exclusively(
                                before: DragGesture()
                                    .onChanged({ value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geometry)
                                    }))
                    )
            })
        })
        .chartBackground(content: { proxy in
            ZStack(alignment: .topLeading, content: {
                GeometryReader(content: { geometry in
                    if let element = selectedElement,
                       let dateInterval: DateInterval = Calendar.current.dateInterval(of: .hour, for: element.scheduleId),
                       let startPosition = proxy.position(forX: dateInterval.start)
                    {

                        let lineX = startPosition + geometry[proxy.plotAreaFrame].origin.x
                        let lineHeight = geometry[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        let boxOffset = max(0, min(geometry.size.width - boxWidth, lineX - boxWidth * 0.5))

                        Rectangle()
                            .fill(.red)
                            .frame(width: 2, height: lineHeight)
                            .position(x: lineX, y: lineHeight * 0.5)

                        VStack(alignment: .center) {
                            Text(element.scheduleId, format: .dateTime.month().day())
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            //                            LazyVGrid(columns: Array(repeating: .init(.fixed(60)), count: 5), content: {
                            //                                ForEach(Array(zip(EnemyId.allCases, element.)), id: \.0, content: { (enemyId, value) in
                            //                                    Image(enemyId)
                            //                                })
                            //                            })
                        }
                        .accessibilityElement(children: .combine)
                        .frame(width: boxWidth, alignment: .center)
                        .background(content: {
                            ZStack(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.primary.opacity(0.2))
                            })
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        })
                        .offset(x: boxOffset)
                    }
                })
            })
        })
        .frame(height: 300)
        //        .frame(width: max(UIScreen.main.bounds.width, CGFloat(enemyResults.count / EnemyKey.allCases.count) * 50), height: 300)
    }

    @available(iOS 16.0, *)
    private var DetailChart: some View {
        Chart(detailResults, content: { entry in
            BarMark(
                x: .value("EnemyId", entry.enemyKey),
                y: .value("Value", Int.random(in: 0...100))
            )
            .foregroundStyle(by: .value("EnemyId", entry.enemyKey))
            //            .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
            //                Text(entry.getValue(action), format: .number)
            //                    .font(.footnote)
            //                    .foregroundColor(.white)
            //                    .fontWeight(.bold)
            //            })
        })
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .frame(height: 300)
    }

    //    @available(iOS 16.0, *)
    //    private func setEnemyChartEntry() {
    //        guard let scheduleId: Date = selectedElement?.scheduleId else {
    //            self.detailResults = []
    //            return
    //        }
    //        self.detailResults = enemyResults.filter({ Calendar.current.isDate($0.scheduleId, inSameDayAs: scheduleId)})
    //    }

    @available(iOS 16.0, *)
    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> EnemyResultEntry? {
        let relativeXPosition: CGFloat = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date: Date = proxy.value(atX: relativeXPosition) as Date? {
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for currentIndex in enemyResults.indices {
                let distance = enemyResults[currentIndex].scheduleId.distance(to: date)
                if abs(distance) < minDistance {
                    minDistance = abs(distance)
                    index = currentIndex
                }
            }

            if let index {
                return enemyResults[index]
            }
        }
        return nil
    }
}

extension EnemyResultEntry {
    func getValue(_ category: EnemyResultCategory) -> Int {
        switch category {
        case .Shift:
            return self.bossKillCountTotal
        case .Team:
            return self.teamBossKillCount
        }
    }
    //
    //    func getDetailValue(_ category: EnemyResultCategory) -> Int {
    //        switch category {
    //        case .Shift:
    //            return self.bossKillCount
    //        case .Team:
    //            return self.teamBossKillCount
    //        }
    //    }
}

extension Array where Element == RealmCoopSchedule {
    func enemyResults(limit: Int) -> [EnemyResultEntry] {
        var bossCountsTotal: [Int] = EnemyKey.allCases.map({ _ in 0 })
        var bossKillCountsTotal: [Int] = EnemyKey.allCases.map({ _ in 0 })
        var teamBossKillCountsTotal: [Int] = EnemyKey.allCases.map({ _ in 0 })

        return self.flatMap({ schedule -> [EnemyResultEntry] in
            bossCountsTotal.add(schedule.bossCounts)
            bossKillCountsTotal.add(schedule.bossKillCounts)
            teamBossKillCountsTotal.add(schedule.teamBossKillCounts)

            guard let startTime: Date = schedule.startTime,
                  let index: Int = self.lastIndex(of: schedule)
            else {
                return []
            }
            if index < self.count - limit {
                return []
            }

            /// チャートのエントリーを返す
            return zip(EnemyKey.allCases, schedule.bossKillCounts ,bossKillCountsTotal, bossCountsTotal, teamBossKillCountsTotal).map({
                enemyKey, solo, total, appear, team -> EnemyResultEntry in
                EnemyResultEntry(
                    schedule: schedule,
                    enemyKey: enemyKey,
                    scheduleId: startTime,
                    bossCount: appear,
                    bossKillCount: solo,
                    bossKillCountTotal: total,
                    teamBossKillCount: team
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

struct EnemyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyChartView()
    }
}

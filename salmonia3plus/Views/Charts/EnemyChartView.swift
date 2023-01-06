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

struct EnemyChartView: View {
    @State private var location: CGPoint? = nil
    @State private var length: Int = 10
    @State private var enemyResults: [EnemyResultEntry] = []
    @State private var element: EnemyResultEntry? = nil
    @State private var scale: CGFloat = 1
    @State private var enemies: [EnemyToggle] = EnemyKey.allCases.map({ EnemyToggle(enemyKey: $0, isPresented: false) })
    @State private var format: FormatCategory = .Number

    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView(showsIndicators: false, content: {
//                Schedule
//                TypePicker
                EnemyChart
                FormatPicker
                EnemyList
//                DetailChart
            })
            .listStyle(.plain)
            .onAppear(perform: {
                Task(priority: .background, operation: {
                    UIApplication.shared.startAnimating(completion:{
                        withAnimation(.easeInOut) {
                            self.enemyResults = getEnemyResults(limit: length)
                        }
                    })
                })
            })
        } else {
            EmptyView()
        }
    }

    private func getEnemyResults(limit: Int = 100) -> [EnemyResultEntry] {
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
    @available(iOS 16.0, *)
    private var FormatPicker: some View {
        Picker("Type", selection: $format.animation(.easeInOut), content: {
            ForEach(FormatCategory.allCases, content: { category in
                Text(category.localized)
                    .tag(category)
            })
        })
        .pickerStyle(.segmented)
    }

    @available(iOS 16.0, *)
    private var EnemyList: some View {
        let entries: [EnemyResultEntry] = {
            if let element = element {
                return enemyResults.filter({ $0.scheduleId == element.scheduleId })
            }
            if let scheduleId: Date = enemyResults.sorted(by: { $0.scheduleId < $1.scheduleId }).first?.scheduleId {
                return enemyResults.filter({ $0.scheduleId == scheduleId })
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
                            ZStack(alignment: .trailing, content: {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.primary.opacity(0.3))
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(SPColor.SplatNet3.SPBlue)
                                switch format {
                                case .Ratio:
                                    Text(entry.bossKillRatio, format: .percent)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .monospacedDigit()
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 4)
                                case .Number:
                                    Text(entry.bossKillTotal.solo, format: .number)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .monospacedDigit()
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 4)
                                }
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
        .padding(.horizontal)
    }

    @available(iOS 16.0, *)
    private var EnemyChart: some View {
        let enemies: [EnemyKey] = enemies.filter({ $0.isPresented }).map({ $0.enemyKey })

        return Chart(enemyResults, content: { entry in
            if enemies.contains(entry.enemyKey) {
                switch format {
                case .Ratio:
                    LineMark(
                        x: .value("Schedule", entry.scheduleId),
                        y: .value("Value", entry.bossKillRatio * 100)
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
                case .Number:
                    LineMark(
                        x: .value("Schedule", entry.scheduleId),
                        y: .value("Value", entry.bossKillTotal.solo)
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
            }
        })
        .chartYScale(domain: .automatic(includesZero: false, reversed: false))
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
                Rectangle()
                    .fill(.red)
                    .frame(width: 2, height: height)
                    .position(x: xValue, y: height * 0.5)
            }
        })
        .frame(height: 300)
        .padding([.leading, .top])
    }
}

extension Array where Element == EnemyResultEntry {
    /// タップした位置に最も近いエレメントを返す
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

class EnemyResultCount {
    let bossCounts: RealmSwift.List<Int> = RealmSwift.List<Int>(contentsOf: Array(repeating: 0, count: 15))
    let bossKillCounts: RealmSwift.List<Int> = RealmSwift.List<Int>(contentsOf: Array(repeating: 0, count: 15))
    let bossTeamCounts: RealmSwift.List<Int> = RealmSwift.List<Int>(contentsOf: Array(repeating: 0, count: 15))

    init() {}

    func add(schedule: RealmCoopSchedule) {
        self.bossCounts.add(contentsOf: schedule.bossCounts)
        self.bossKillCounts.add(contentsOf: schedule.bossKillCounts)
        self.bossTeamCounts.add(contentsOf: schedule.bossTeamCounts)
    }
}

extension Array where Element == RealmCoopSchedule {
    func enemyResults(limit: Int) -> [EnemyResultEntry] {
        /// オオモノ出現数
        let enemyCounts: EnemyResultCount = EnemyResultCount()
        let length: Int = 100

        return self.flatMap({ schedule -> [EnemyResultEntry] in
            /// 累計オオモノ出現数
            enemyCounts.add(schedule: schedule)

            guard let startTime: Date = schedule.startTime,
                  let index: Int = self.lastIndex(of: schedule)
            else {
                return []
            }
            if index < self.count - limit {
                return []
            }

            /// チャートのエントリーを返す
            return zip(EnemyKey.allCases, enemyCounts.bossCounts, enemyCounts.bossKillCounts, enemyCounts.bossTeamCounts).map({
                enemyKey, bossCount, bossKillCount, bossTeamCounts -> EnemyResultEntry in
                let index: Int = EnemyKey.allCases.firstIndex(of: enemyKey) ?? 0
                return EnemyResultEntry(
                    //                    schedule: schedule,
                    enemyKey: enemyKey,
                    scheduleId: startTime,
                    bossCount: EnemyCount(shift: schedule.bossCounts[index], total: bossCount),
                    bossKillCount: EnemyKillCount(solo: schedule.bossKillCounts[index], team: schedule.bossTeamCounts[index]),
                    bossKillTotal: EnemyKillCount(solo: bossKillCount, team: bossTeamCounts)
                )
            })
        })
    }
}


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

struct EnemyToggle: Equatable {
    let enemyKey: EnemyKey
    var isPresented: Bool

    internal init(enemyKey: EnemyKey, isPresented: Bool) {
        self.enemyKey = enemyKey
        self.isPresented = isPresented
    }
}

struct EmptySymbol: ChartSymbolShape {
    var perceptualUnitRect: CGRect = .zero

    func path(in rect: CGRect) -> Path {
        .init()
    }
}

struct EnemyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyChartView()
    }
}

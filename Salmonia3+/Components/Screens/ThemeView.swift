//
//  ThemeView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/23.
//

import SwiftUI
import SplatNet3
import Charts

/// アプリの見た目などを変更します
struct ThemeView: View {
    @EnvironmentObject var appearances: Appearance

    var body: some View {
        List(content: {
            SPToggle(isPresented: appearances.$colorScheme, bundle: .L_BtnOption_07_T_Header_00)
            SPToggle(isPresented: appearances.$gamingScheme, bundle: .CoopHistory_Limited)
        })
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .L_Bottom_05_T_Info_00))
    }
}

enum ChartValueMethod: Int, Codable, CaseIterable {
    case estimate
    case actual
}

enum ChartInterpolationMethod: Int, Codable, CaseIterable {
    case cardinal
    case catmullRom
    case linear
    case monotone
    case stepCenter
    case stepEnd
    case stepStart
}

enum ChartTransitionStyle: Int, Codable, CaseIterable {
    case coverVertical
    case flipHolizontal
    case crossDissolve
    case partialCurl
}

enum ChartResultStyle: Int, Codable, CaseIterable {
    case splatnet2
    case splatnet3
}

public class Appearance: ObservableObject {
    /// 色覚サポート
    @AppStorage("APP_PREFERRED_COLOR_SCHEME") var colorScheme: Bool = false
    /// ゲーミングモード
    @AppStorage("APP_PREFERRED_GAMING_SCHEME") var gamingScheme: Bool = false
    /// チャート形式
    @AppStorage("APP_CHART_INTERPOLATION_METHOD") var interpolationMethod: ChartInterpolationMethod = .stepCenter
    /// チャート値計算式
    @AppStorage("APP_CHART_TECHNICAL_METHOD") var technicalMethod: ChartValueMethod = .estimate
    /// リザルト詳細形式
    @AppStorage("APP_RESULT_VIEW_STYLE") var resultStyle: ChartResultStyle = .splatnet3
}

private struct SPToggle: View {
    @Binding var isPresented: Bool
    let bundle: LocalizedType

    var body: some View {
        Toggle(isOn: $isPresented, label: {
            Text(bundle: bundle)
                .font(systemName: .Splatfont2, size: 16)
        })
        .toggleStyle(.splatoon)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

private struct GamingToggle: View {
    @AppStorage(LocalizedType.L_BtnOption_07_T_Header_00.rawValue) var isPresented: Bool = false

    var body: some View {
        Toggle(isOn: $isPresented, label: {
            Text(bundle: .L_BtnOption_07_T_Header_00)
                .font(systemName: .Splatfont2, size: 16)
        })
        .toggleStyle(.splatoon)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}

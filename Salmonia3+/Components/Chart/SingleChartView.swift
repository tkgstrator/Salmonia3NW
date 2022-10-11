//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts

public class SingleData: ObservableObject, Identifiable {
    @Published var maxValue: Int?
    @Published var minValue: Int?
    @Published var avgValue: Double?

    var valuesGiven: Bool = false
    var ID = UUID()

    public init(max: Int?, min: Int?, avg: Double?) {
        self.maxValue = {
            if let max = max {
                return max
            }
            return nil
        }()
        self.minValue = {
            if let min = min {
                return min
            }
            return nil
        }()
        self.avgValue = {
            if let avg = avg {
                return Double(avg)
            }
            return nil
        }()
    }
}

struct AnimatableNumberModifier: AnimatableModifier {
    var number: Double

    var animatableData: Double {
        get { number }
        set { number = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(Text(String(format: "%.1f", number)).font(.system(size: 16, design: .monospaced)), alignment: .trailing)
    }
}

enum ChartType: CaseIterable {
    /// 個人記録
    case Solo
    /// チーム記録
    case Team
    /// なし
    case None
}

struct SingleChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: ChartData
    @State private var scale: Double = .zero
    public var title: Text
    public var valueSpecifier: String

    public init(
        value: [Double],
        title: Text,
        valueSpecifier: String? = "%.1f"
    ) {
        self.data = ChartData(points: value)
        self.title = title
        self.valueSpecifier = valueSpecifier!
    }

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 4)
            Spacer()
            VStack(alignment: .leading, spacing: 8, content: {
                GeometryReader(content: { geometry in
                    Line(data: self.data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: .constant(.zero),
                         showIndicator: .constant(false),
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                })
                .clipShape(RoundedRectangle(cornerRadius: 20))
            })
        })
        .padding([.horizontal])
        .aspectRatio(340/160, contentMode: .fit)
    }
}

extension View {
    func animation(for number: Double) -> some View {
        self.modifier(AnimatableNumberModifier(number: number))
    }
}

extension Image {
    init(bundle: ChartType) {
        switch bundle {
        case .Solo:
            self.init(bundle: ButtonType.Solo)
        case .Team:
            self.init(bundle: ButtonType.Team)
        case .None:
            self.init(bundle: ButtonType.Solo)
        }
    }
}

struct SingleChartView_Previews: PreviewProvider {
    static var previews: some View {
        SingleChartView(value: [10, 20, 10, 40, 35, 25, 0], title: Text(bundle: .CoopHistory_JobRatio))
            .preferredColorScheme(.dark)
    }
}

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
            .overlay(Text(String(format: "%.1f", number)).monospacedDigit(), alignment: .trailing)
    }
}

struct SingleChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: SingleData
    @State private var scale: Double = .zero
    public var title: Text
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle

    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier: String

    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?

    public init(
        data: Stats,
        title: Text,
        legend: String? = nil,
        style: ChartStyle = Styles.lineChartStyleOne,
        form: CGSize? = ChartForm.small,
        rateValue: Int? = 14 ,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f") {
            self.data = SingleData(max: data.maximum, min: data.minimum, avg: data.average)
            self.title = title
            self.legend = legend
            self.style = style
            self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
            self.formSize = form!
            frame = CGSize(width: self.formSize.width, height: self.formSize.height * 0.5)
            self.dropShadow = dropShadow!
            self.valueSpecifier = valueSpecifier!
            self.rateValue = rateValue
        }

    public init(
        max: Int?,
        min: Int?,
        avg: Double,
        title: Text,
        legend: String? = nil,
        style: ChartStyle = Styles.lineChartStyleOne,
        form: CGSize? = ChartForm.small,
        rateValue: Int? = 14 ,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f"
    ) {
        self.data = SingleData(max: max, min: min, avg: avg)
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form!
        frame = CGSize(width: self.formSize.width, height: self.formSize.height * 0.5)
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.rateValue = rateValue
    }

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                .frame(width: frame.width, height: 160, alignment: .center)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 4 : 0)
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 8, content: {
                    self.title
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    if let legend = legend {
                        Text(legend)
                            .font(.callout)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }
                })
                .transition(.opacity)
                .animation(.easeIn(duration: 0.1), value: UUID())
                .padding([.leading, .top])
                Spacer()
                VStack(alignment: .leading, spacing: 0, content: {
                    HStack(content: {
                        Text("Max")
                            .font(.system(size: 16, design: .monospaced))
                        Spacer()
                        if let maxValue = data.maxValue {
                            Color.clear
                                .animation(for: Double(maxValue) * scale)
                        } else {
                            Text("-")
                        }
                    })
                    .frame(height: 24)
                    HStack(content: {
                        Text("Min")
                            .font(.system(size: 16, design: .monospaced))
                        Spacer()
                        if let minValue = data.minValue {
                            Color.clear
                                .animation(for: Double(minValue) * scale)
                        } else {
                            Text("-")
                        }
                    })
                    .frame(height: 24)
                    HStack(content: {
                        Text("Avg")
                            .font(.system(size: 16, design: .monospaced))
                        Spacer()
                        if let avgValue = data.avgValue {
                            Color.clear
                                .animation(for: Double(avgValue) * scale)
                        } else {
                            Text("-")
                        }
                    })
                    .frame(height: 24)
                })
                .font(.callout)
                .padding([.horizontal, .top])
                .frame(width: frame.width, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(width: self.formSize.width, height: self.formSize.height)
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 2.0)) {
                    self.scale = 1.0
                }
            })
        })
    }
}

extension View {
    func animation(for number: Double) -> some View {
        self.modifier(AnimatableNumberModifier(number: number))
    }
}

struct SingleChartView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleStatsView(startTime: Date(rawValue: "2022-01-01T00:00:00+09:00")!)
            .preferredColorScheme(.dark)
    }
}

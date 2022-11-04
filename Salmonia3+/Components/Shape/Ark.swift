//
//  Ark.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/09.
//

import SwiftUI
import UIKit

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    var insetAmount: CGFloat = .zero

    init(from: CGFloat, to: CGFloat) {
        self.startAngle = .degrees(360 * from - 90)
        self.endAngle = .degrees(360 * to - 90)
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = min(rect.maxX, rect.maxY) * 0.5 - insetAmount
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: false)
        return path
    }
}

struct HalfCircle: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var insetAmount: CGFloat = .zero

    init(from: CGFloat, to: CGFloat) {
        self.startAngle = .degrees(from * 360)
        self.endAngle = .degrees(to * 360)
    }

//    var animatableData: AnimatablePair<Double, Double> {
//        get {
//            AnimatablePair(startAngle.degrees, endAngle.degrees)
//        }
//        set {
//            startAngle = Angle(degrees: newValue.first)
//            endAngle = Angle(degrees: newValue.second)
//        }
//    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }

    func path(in rect: CGRect) -> Path {
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        let rMax: CGFloat = min(rect.maxX, rect.maxY) * 0.5 - insetAmount
        let rMin: CGFloat = min(rect.maxX, rect.maxY) * 0.25 - insetAmount

        var path = Path()
        path.addArc(center: center, radius: rMax, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: rMin, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        return path
    }
}

struct HalfCircle_Previews: PreviewProvider {
    @State static var from: CGFloat = 0.0
    @State static var to: CGFloat = 0.3

    static var previews: some View {
        HalfCircle(from: from, to: to)
            .fill(Color.pink)
            .frame(width: 300, height: 300, alignment: .center)
            .onTapGesture(perform: {
                withAnimation {
                    to += 0.1
                }
            })
    }
}

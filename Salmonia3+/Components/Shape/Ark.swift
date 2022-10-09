//
//  Ark.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI

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

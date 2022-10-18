//
//  Line.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/16.
//

import SwiftUI

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
struct Line_Previews: PreviewProvider {
    static var previews: some View {
        DashedLine()
    }
}

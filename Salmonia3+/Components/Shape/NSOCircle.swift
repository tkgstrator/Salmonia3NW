//
//  NSOCircle.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI

struct NSOCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.8846*width, y: 0.86808*height), control1: CGPoint(x: width, y: 0.63756*height), control2: CGPoint(x: 0.96368*width, y: 0.789*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: 0.80552*width, y: 0.94716*height), control2: CGPoint(x: 0.6794*width, y: height))
        path.addCurve(to: CGPoint(x: 0.1154*width, y: 0.86808*height), control1: CGPoint(x: 0.3206*width, y: height), control2: CGPoint(x: 0.19448*width, y: 0.94716*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.5*height), control1: CGPoint(x: 0.03632*width, y: 0.789*height), control2: CGPoint(x: 0, y: 0.63756*height))
        path.addCurve(to: CGPoint(x: 0.1154*width, y: 0.13192*height), control1: CGPoint(x: 0, y: 0.36244*height), control2: CGPoint(x: 0.03632*width, y: 0.211*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0.19448*width, y: 0.05284*height), control2: CGPoint(x: 0.3206*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.8846*width, y: 0.13192*height), control1: CGPoint(x: 0.6794*width, y: 0), control2: CGPoint(x: 0.80552*width, y: 0.05284*height))
        path.addCurve(to: CGPoint(x: width, y: 0.5*height), control1: CGPoint(x: 0.96368*width, y: 0.211*height), control2: CGPoint(x: width, y: 0.3624*height))
        path.closeSubpath()
        return path
    }
}

struct NSOCircle_Previews: PreviewProvider {
    static var previews: some View {
        NSOCircle()
            .scaledToFit()
            .previewLayout(.fixed(width: 120, height: 120))
    }
}

//
//  Charts.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/07
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import Charts
import SwiftUI

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
//                            scale.wrappedValue = max(1.0, min(5.0, 1.0 + value.magnitude * 0.1))
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



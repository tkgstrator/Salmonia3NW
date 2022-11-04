//
//  Rainbow.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/29.
//

import SwiftUI

struct Rainbow: View {
    @State private var isPresented: Bool = false
    let duration: Double = 1.5
    let colors: [Color] = stride(from: 0, to: 1, by: 0.01).map({ Color(hue: $0, saturation: 1, brightness: 0.9) })
    var animation: Animation {
        Animation
            .easeInOut(duration: duration)
            .delay(1)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        GeometryReader(content: { geometry in
            LinearGradient(gradient: Gradient(colors: colors + colors), startPoint: .leading, endPoint: .trailing)
                .frame(width: geometry.size.width * 2)
        })
    }
}

struct RainbowAnimation: ViewModifier {
    @State var isPresented: Bool = false
    let colors: [Color] = stride(from: 0, to: 1, by: 0.01).map({ Color(hue: $0, saturation: 1, brightness: 1) })
    let animation: Animation = Animation.linear(duration: 4).repeatForever(autoreverses: false)

    func body(content: Content) -> some View {
        return ZStack(alignment: .center, content: {
            GeometryReader(content: { geometry in
                LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: 2 * geometry.size.width)
                    .offset(x: isPresented ? -geometry.size.width * 0.5 : geometry.size.width * 0.5)
            })
            content
        })
        .onAppear(perform: {
            withAnimation(animation) {
                isPresented = true
            }
        })
    }
}

struct Rainbow_Previews: PreviewProvider {
    static var previews: some View {
        Rainbow()
            .edgesIgnoringSafeArea(.all)
    }
}

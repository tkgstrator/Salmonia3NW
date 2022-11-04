//
//  ToggleStyle.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/11/04.
//  
//

import SwiftUI
import SplatNet3

struct SPToggleStyle: ToggleStyle {
    let backgroundColor: Color = Color(.label)
    let switchColor: Color = Color(.systemBackground)

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 224, height: 38, alignment: .center)
                    .foregroundColor(.black)
                ZStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 110, height: 34, alignment: .center)
                        .foregroundColor(SPColor.SplatNet3.SPYellow)
                        .offset(x: configuration.isOn ? -55 : 55, y: 0)
                        .animation(.linear, value: configuration.isOn)
                    HStack(spacing: 0, content: {
                        Text(bundle: .L_BtnOption_02_T_BtnL_00)
                            .bold()
                            .frame(width: 110, height: 34, alignment: .center)
                            .foregroundColor(configuration.isOn ? .black : .white)
                        Text(bundle: .L_BtnOption_02_T_BtnR_00)
                            .bold()
                            .frame(width: 110, height: 34, alignment: .center)
                            .foregroundColor(configuration.isOn ? .white : .black)
                    })
                })
            })
            .onTapGesture(perform: {
                withAnimation(.linear(duration: 0.5)){
                    configuration.isOn.toggle()
                }
            })
        }
    }
}

extension ToggleStyle where Self == SPToggleStyle {
    internal static var splatoon: SPToggleStyle { SPToggleStyle() }
}

struct ToggleStyle_Previews: PreviewProvider {
    @State private static var isPresented: Bool = false

    static var previews: some View {
        Toggle(isOn: $isPresented, label: {
            Text("Toggle")
        })
        .toggleStyle(.splatoon)
    }
}

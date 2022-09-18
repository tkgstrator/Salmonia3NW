//
//  TypePicker.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3
import Introspect

public protocol AllCaseable: RawRepresentable, Identifiable, CaseIterable, Hashable where RawValue == String, AllCases: RandomAccessCollection { }

struct TypePicker<T: AllCaseable>: View {
    @Binding var selection: SplatNet2.Rule

    var body: some View {
        Picker(selection: $selection, content: {
            ForEach(T.allCases) { rule in
                Text(localizedText: rule.rawValue)
                    .tag(rule)
            }
        }, label: {
        })
        .pickerStyle(.segmented)
        .introspectSegmentedControl(customize: { controller in
            controller.selectedSegmentTintColor = UIColor(hex: "FF7500")
            controller.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Splatfont2", size: 16)!], for: .selected)
            controller.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Splatfont2", size: 16)!], for: .normal)
        })
    }
}

//struct TypePicker_Previews: PreviewProvider {
//    @State static var selection: SplatNet2.Rule = .REGULAR
//
//    static var previews: some View {
//        TypePicker(selection: $selection)
//            .previewLayout(.fixed(width: 400, height: 100))
//    }
//}

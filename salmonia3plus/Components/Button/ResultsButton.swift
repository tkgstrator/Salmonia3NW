//
//  ResultsButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/04
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ResultsButton: View {
    @ObservedResults(RealmCoopResult.self) var results
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Squid)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Job_Works, color: SPColor.SplatNet3.SPXMatch))
        .confirmationDialog(
            Text("保存されているリザルト件数"),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
            }, label: {
                Text("\(results.count)件")
            })
        }, message: {
            Text(bundle: .Common_Get_Schedules_Txt)
        })
    }
}

struct ResultsButton_Previews: PreviewProvider {
    static var previews: some View {
        ResultsButton()
    }
}

//
//  DeleteButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct DeleteButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Defeated)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Wipe_Data, color: SPColor.SplatNet3.SPPink))
        .confirmationDialog(
            Text(bundle: .Common_Wipe_Data),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
                Task {
                    await RealmService.shared.deleteAll(options: [.SCHEDULE])
                }
            }, label: {
                Text(bundle: .StageSchedule_Title)
            })
            Button(action: {
                Task {
                    await RealmService.shared.deleteAll(options: [.RESULT])
                }
            }, label: {
                Text(bundle: .CoopHistory_History)
            })
            Button(action: {
                Task {
                    await RealmService.shared.deleteAll()
                }
            }, label: {
                Text(bundle: .Common_Decide)
            })
        }, message: {
            Text(bundle: .Common_Wipe_Data_Txt)
        })
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton()
    }
}

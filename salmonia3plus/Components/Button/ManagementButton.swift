//
//  DeleteButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ManagementButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(role: .destructive, action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Wipe_Results)
        })
        .confirmationDialog(
            Text(bundle: .Custom_Wipe_Results),
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
                Text(bundle: .Custom_Wipe_All)
            })
        }, message: {
            Text(bundle: .Custom_Wipe_Results_Txt)
        })
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        ManagementButton()
    }
}

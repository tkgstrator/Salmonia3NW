//
//  ScheduleButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/04
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ScheduleButton: View {
    @EnvironmentObject var session: Session
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Refresh)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Get_Schedules, color: SPColor.SplatNet3.SPBankara))
        .confirmationDialog(
            Text(bundle: .Common_Get_Schedules),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
                Task {
                    do {
                        let schedules: [CoopSchedule] = try await session.getAllCoopStageScheduleQuery()
                        await RealmService.shared.update(schedules)
                    } catch(let error) {
                        print(error)
                    }
                }
            }, label: {
                Text(bundle: .Common_Decide)
            })
        }, message: {
            Text(bundle: .Common_Get_Schedules_Txt)
        })
    }
}

struct ScheduleButton_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleButton()
    }
}

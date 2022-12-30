//
//  MenuButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct _MenuView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ResultLabel()
                    LogLabel()
                    StatsToggle()
                }, header: {
                    Text(bundle: .Custom_User_Data)
                })
                Section(content: {
                    ThemeToggle()
                    GamingToggle()
                    LanguageButton()
                }, header: {
                    Text(bundle: .Custom_Appearances)
                })
                Section(content: {
                    FileBackupButton()
                    FilePickerButton()
                }, header: {
                    Text(bundle: .Custom_Data_Management)
                })
                Section(content: {
                    PrivacyLink()
                    FAQLink()
                    SourceLink()
                    CreditLink()
                    LogButton()
                    VersionLabel()
                }, header: {
                    Text(bundle: .Custom_Application)
                })
                Section(content: {
                    LogDeleteButton()
                    ManagementButton()
                    UnlinkButton()
                })
            })
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(bundle: .Settings_Title))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text(bundle: .Common_Close)
                    })
                })
            })
        })
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
       _MenuView()
    }
}

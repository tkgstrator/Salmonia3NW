//
//  MenuButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct MenuButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Menu)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32, alignment: .center)
        })
        .sheet(isPresented: $isPresented, content: {
            _MenuView()
        })
    }
}

struct _MenuView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ResultLabel()
                    LogLabel()
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

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton()
            .preferredColorScheme(.dark)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
       _MenuView()
            .preferredColorScheme(.dark)
    }
}

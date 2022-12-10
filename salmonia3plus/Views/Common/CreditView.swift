//
//  CreditView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct CreditView: View {
    var body: some View {
        List(content: {
            Section(content: {
                ForEach(UserType.allCases, content: { user in
                    _User(user: user)
                })
            }, header: {
                Text("Contributors")
            })
        })
        .navigationTitle(Text(bundle: .Settings_Credits))
    }
}

private struct _User: View {
    let user: UserType

    var body: some View {
        HStack(alignment: .center, content: {
            Image(user: user)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, content: {
                Text(user.name)
                Text(user.role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            })
        })
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        CreditView()
    }
}

struct _UserView_Previews: PreviewProvider {
    static var previews: some View {
        _User(user: .Tkgling)
    }
}

//
//  IconView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI

enum IconType: String, CaseIterable {
    case Gear       = "gear"
    case Review     = "pencil.and.outline"
    case Theme      = "circle.lefthalf.filled"
    case Trash      = "trash"

    var localizedText: String {
        switch self {
        case .Gear:
            return NSLocalizedString("TITLE_SETTING".sha256Hash, comment: "")
        case .Review:
            return NSLocalizedString("TITLE_REVIEW".sha256Hash, comment: "")
        case .Theme:
            return NSLocalizedString("TITLE_THEME".sha256Hash, comment: "")
        case .Trash:
            return NSLocalizedString("TITLE_TRASH".sha256Hash, comment: "")
        }
    }
}

struct IconButton: View {
    let icon: IconType
    let execute: (() -> Void)

    init(icon: IconType, execute: @escaping () -> Void) {
        self.icon = icon
        self.execute = execute
    }

    var label: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Image(systemName: icon.rawValue)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(14)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(NSOCircle())
            Text(icon.localizedText)
                .font(systemName: .Splatfont, size: 16)
                .frame(height: 16)
        })
    }

    var body: some View {
        Button(action: {
            execute()
        }, label: {
            label
        })
        .buttonStyle(.plain)
    }
}

struct IconView<Content: View>: View {

    let icon: IconType
    let content: (() -> Content)

    init(icon: IconType, destination: @escaping (() -> Content)) {
        self.icon = icon
        self.content = destination
    }

    var label: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Image(systemName: icon.rawValue)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(14)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(NSOCircle())
            Text(icon.localizedText)
                .font(systemName: .Splatfont, size: 16)
                .frame(height: 16)
        })
    }

    var body: some View {
        NavigationLink(destination: {
            content()
        }, label: {
            label
        })
        .buttonStyle(.plain)
    }
}

//struct IconView_Previews: PreviewProvider {
//    static var previews: some View {
//        IconView(icon: .Review)
//            .previewLayout(.fixed(width: 120, height: 120))
//    }
//}

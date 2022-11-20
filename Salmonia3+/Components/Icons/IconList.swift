//
//  DebugIcon.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/23.
//

import SwiftUI
import StoreKit
import BetterSafariView
import SplatNet3

enum IconList {
    static let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

    struct NSO: View {
        @StateObject var session: Session = Session()
        @State private var isPresented: Bool = false
        @AppStorage("CONFIG_APP_DEVELOPER_MODE") var isAppDeveloperMode: Bool = true

        var body: some View {
            if let account = session.account {
                Image(bundle: .User)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .actionCircleButton(title: account.nickname, action: {
                        isAppDeveloperMode.toggle()
                    })
            } else {
                EmptyView()
            }
        }
    }

    struct Debug: View {
        var body: some View {
            Image(bundle: .Mission_Lv00)
                .resizable()
                .scaledToFit()
                .navigationCircleButton(
                    title: "TITLE_DEBUG",
                    destination: {
                        DebugView()
                    })
        }
    }

    struct Form: View {
        var body: some View {
            Image(bundle: .Squid)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    bundle: .Common_Share,
                    destination: {
                        NotionForm()
                    })
        }
    }

    struct Privacy: View {
        @State private var isPresented: Bool = false

        var body: some View {
            Image(bundle: .Privacy)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Privacy_Policy,
                    action: {
                        isPresented.toggle()
                    })
                .safariView(isPresented: $isPresented, content: {
                    SafariView(url: URL(unsafeString: "https://documents.splatnet3.com"))
                })
        }
    }

    struct Review: View {
        @AppStorage("CONFIG_APP_DEVELOPER_MODE") var isAppDeveloperMode: Bool = true

        var body: some View {
            Image(bundle: .Review)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Write_Review,
                    action: {
                        if let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first(where: { $0.activationState == .foregroundActive }) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                SKStoreReviewController.requestReview(in: scene)
                            })
                        }
                    })
        }
    }

    struct Setting: View {
        var body: some View {
            Image(bundle: .Defeated)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    bundle: .Common_Data_Managements,
                    destination: {
                        DeleteConfirmView()
                    })
        }
    }

    struct Appearance: View {
        var body: some View {
            Image(bundle: .Wear)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    bundle: .Common_Customize,
                    destination: {
                        ThemeView()
                    })
        }
    }

    struct Chart: View {
        var body: some View {
            Image(bundle: .LineChart)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Charts,
                    action: {
                    let encoder: JSONEncoder = {
                        let encoder: JSONEncoder = JSONEncoder()
                        encoder.keyEncodingStrategy = .convertToSnakeCase
                        encoder.outputFormatting = .prettyPrinted
                        return encoder
                    }()
                    let results: [JSONCoopResult] = RealmService.shared.exportToJSON()
                    do {
                        let data = try encoder.encode(results)
                        let fileName: String = {
                            let formatter: DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyymmddHHMMss"
                            return formatter.string(from: Date())
                        }()
                        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                            return
                        }
                        let filePath: URL = dir.appendingPathComponent(fileName).appendingPathExtension("json")
                        /// データ書き込み
                        try data.write(to: filePath, options: .atomic)
                        let items = [filePath]
                        let activity: UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        UIApplication.shared.rootViewController?.popover(activity, animated: true)
                    } catch {

                    }
                })
        }
    }

    struct Schedule: View {
        @StateObject var session: Session = Session()
        @State private var isPresented: Bool = false

        var body: some View {
            Image(bundle: .Arrows)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Get_Schedules,
                    action: {
                        isPresented.toggle()
                    })
                .alert(
                    isPresented: $isPresented,
                    title: Text(bundle: .Common_Get_Schedules),
                    message: Text(bundle: .Common_Get_Schedules_Txt),
                    confirm: {
                        Task {
                            let schedules: [CoopSchedule.Response] = try await session.getAllCoopSchedule()
                            RealmService.shared.save(schedules)
                        }
                    })
        }
    }

    struct Results: View {
        @State private var isPresented: Bool = false

        var body: some View {
            Image(bundle: .Salmon)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Wipe_Results,
                    action: {
                    isPresented.toggle()
                })
                .alert(
                    isPresented: $isPresented,
                    title: Text(bundle: .Common_Wipe_Results),
                    message: Text(bundle: .Common_Wipe_Results_Txt),
                    confirm: {
                        RealmService.shared.deleteAll()
                    })
        }
    }

    struct Accounts: View {
        @AppStorage("CONFIG_IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
        @State private var isPresented: Bool = false
        @StateObject var session: Session = Session()

        var body: some View {
            Image(bundle: .Review)
                .resizable()
                .scaledToFit()
                .padding()
                .actionCircleButton(
                    bundle: .Common_Unlink_Accounts,
                    action: {
                    isPresented.toggle()
                })
                .alert(
                    isPresented: $isPresented,
                    title: Text(bundle: .Common_Unlink_Accounts),
                    message: Text(bundle: .Common_Unlink_Accounts_Txt),
                    confirm: {
                        try? session.removeAll()
                        isFirstLaunch.toggle()
                    })
        }
    }
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let confirm: () -> Void
    let title: Text
    let message: Text

    init(isPresented: Binding<Bool>, title: Text, message: Text, confirm: @escaping () -> Void) {
        self._isPresented = isPresented
        self.confirm = confirm
        self.title = title
        self.message = message
    }

    func body(content: Content) -> some View {
        content
            .alert(self.title, isPresented: $isPresented) {
                Button(role: .destructive, action: {
                    confirm()
                }, label: {
                    Text(bundle: .Common_Decide)
                })
            } message: {
                self.message
            }
    }
}

extension View {
    /// アラートで許可を押した場合に指定した処理を実行
    func alert(
        isPresented: Binding<Bool>,
        title: Text,
        message: Text,
        confirm: @escaping () -> Void
    ) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, title: title, message: message, confirm: confirm))
    }
}

struct IconList_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .previewLayout(.fixed(width: 400, height: 600))
        UserView()
            .previewLayout(.fixed(width: 400, height: 600))
            .preferredColorScheme(.dark)
    }
}

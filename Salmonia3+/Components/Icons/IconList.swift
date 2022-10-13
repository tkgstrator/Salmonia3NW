//
//  DebugIcon.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/23.
//

import SwiftUI
import SDWebImageSwiftUI
import StoreKit
import BetterSafariView
import SplatNet3

enum IconList {
    static let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

    struct NSO: View {
        @StateObject var session: Session = Session()
        @State private var isPresented: Bool = false

        var body: some View {
            if let account = session.account {
                Button(action: {
                    IconList.generator.notificationOccurred(.success)
                    isPresented.toggle()
                }, label: {
                    VStack(alignment: .center, spacing: nil, content: {
                        Image(bundle: .User)
//                        WebImage(url: account.thumbnailURL)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .background(NSOCircle().fill(SPColor.SplatNet2.SPOrange))
                            .clipShape(NSOCircle())
                        Text(account.nickname)
                            .font(systemName: .Splatfont2, size: 14)
                            .lineLimit(1)
                            .frame(height: 16)
                            .foregroundColor(.primary)
                    })
                })
                .frame(maxWidth: 100)
            } else {
                EmptyView()
            }
        }
    }

    struct Debug: View {
        @AppStorage("CONFIG_APP_DEVELOPER_MODE") var isAppDeveloperMode: Bool = true

        var body: some View {
            Image(bundle: .Mission_Lv00)
                .resizable()
                .scaledToFit()
                .navigationCircleButton(
                    localizedText: "TITLE_DEBUG",
                    destination: {
                        DebugView()
                    })
                .disabled(!isAppDeveloperMode)
                .opacity(isAppDeveloperMode ? 1.0 : 0.0)
        }
    }

    struct Privacy: View {
        @State private var isPresented: Bool = false

        var body: some View {
            Image(bundle: .CatalogueLevel_Lv00)
                .resizable()
                .scaledToFit()
                .actionCircleButton(
                    localizedText: "TITLE_PRIVACY",
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
                    localizedText: "TITLE_REVIEW",
                    action: {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    })
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 5, maximumDistance: 10).onEnded({ _ in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAppDeveloperMode.toggle()
                        }
                    })
                )
        }
    }

    struct Setting: View {
        var body: some View {
            Image(bundle: .Defeated)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    localizedText: "TITLE_ERASE",
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
                    localizedText: "TITLE_APPEARANCE",
                    destination: {
                        ThemeView()
                    })
        }
    }

    struct Friends: View {
        var body: some View {
            Image(bundle: .Mission_Lv03)
                .resizable()
                .scaledToFit()
                .navigationCircleButton(
                    localizedText: "TITLE_FRIENDS",
                    destination: {
                        EmptyView()
                    })
        }
    }

    struct Status: View {
        var body: some View {
            Image(bundle: .CoopBossKillNum_SakelienGiant_Lv00)
                .resizable()
                .scaledToFit()
                .navigationCircleButton(
                    localizedText: "TITLE_STATUS",
                    destination: {
                        EmptyView()
                    })
        }
    }

    struct Chart: View {
        var body: some View {
            Image(bundle: .LineChart)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    localizedText: "TITLE_CHART",
                    destination: {
                        EmptyView()
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
                    localizedText: Text(bundle: .StageSchedule_Title),
                    action: {
                        isPresented.toggle()
                    })
                .alert(isPresented: $isPresented, title: Text(bundle: .StageSchedule_Title), message: Text(bundle: .Widgets_Loading), confirm: {
                    Task {
                        let schedules: [CoopSchedule.Response] = try await session.getAllCoopSchedule()
                        DispatchQueue.main.async(execute: {
                            RealmService.shared.save(schedules)
                        })
                    }
                })
        }
    }

    struct Erase: View {
        var body: some View {
            Image(bundle: .Defeated)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationCircleButton(
                    localizedText: "TITLE_ERASE",
                    destination: {
                        EmptyView()
                    })
        }
    }

    struct Results: View {
        @State private var isPresented: Bool = false

        var body: some View {
            Image("ButtonType/Salmon", bundle: .main)
                .resizable()
                .scaledToFit()
                .actionCircleButton(localizedText: "TITLE_ERASE_RESULTS", action: {
                    isPresented.toggle()
                })
                .alert(isPresented: $isPresented, confirm: {
                    RealmService.shared.deleteAll()
                })
        }
    }

    struct Accounts: View {
        @AppStorage("CONFIG_IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
        @State private var isPresented: Bool = false

        var body: some View {
            Image("TabType/Ika1", bundle: .main)
                .resizable()
                .scaledToFit()
                .actionCircleButton(localizedText: "TITLE_ERASE_ACCOUNTS", action: {
                    isPresented.toggle()
                })
                .alert(isPresented: $isPresented, confirm: {
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
        title: Text = Text(localizedText: "TITLE_CONFIRM_DANGER"),
        message: Text = Text(localizedText: "DESC_DANGER_ERASE"),
        confirm: @escaping () -> Void) -> some View {
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

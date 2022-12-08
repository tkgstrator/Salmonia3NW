//
//  ContentView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import SplatNet3
import Introspect

struct ContentView: View {
    @StateObject private var session: Session = Session()
    @State private var isPresented: Bool = false

    var body: some View {
        _ContentView()
            .environment(\.isModalPresented, $isPresented)
            .edgesIgnoringSafeArea(.all)
            .fullScreen(isPresented: $isPresented, session: session)
    }
}

extension UIImage {
    convenience init?(icon: IconType) {
        self.init(named: "Icon/\(icon.rawValue)", in: .main, with: nil)
    }
}

private struct _ContentView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
    }

    func makeUIViewController(context: Context) -> UITabBarController {
        let controller = UITabBarController()
        let mypage = UIHostingController(rootView: NavigationView(content: { MyPageView() }).navigationViewStyle(.split))
        let result = UIHostingController(rootView: NavigationView(content: { ResultsView() }).navigationViewStyle(.split))
        let schedule = UIHostingController(rootView: NavigationView(content: { SchedulesView() }).navigationViewStyle(.split))

        mypage.tabBarItem = UITabBarItem(title: LocalizedType.Common_MyPage.localized, image: UIImage(icon: .Me), tag: 0)
        result.tabBarItem = UITabBarItem(title: LocalizedType.CoopHistory_History.localized, image: UIImage(icon: .Home), tag: 1)
        schedule.tabBarItem = UITabBarItem(title: LocalizedType.StageSchedule_Title.localized, image: UIImage(icon: .Home), tag: 1)
        controller.setViewControllers([mypage, result, schedule], animated: true)
        return controller
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    }

    class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
        required init?(coder: NSCoder) {
            fatalError()
        }

        init() {
            super.init(nibName: nil, bundle: nil)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        }

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
